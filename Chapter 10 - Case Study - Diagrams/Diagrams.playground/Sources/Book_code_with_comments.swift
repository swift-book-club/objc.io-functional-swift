//: Playground - noun: a place where people can play

import Cocoa

//Make it easy to get the context we'll be using
extension NSGraphicsContext {
    var cgContext: CGContextRef {
        let opaqueContext = COpaquePointer(self.graphicsPort)
        return Unmanaged<CGContextRef>.fromOpaque(opaqueContext)
            .takeUnretainedValue()
    }
}

public extension SequenceType where Generator.Element == CGFloat {
    //Rescale a sequence of floats so all values are between 0 and 1
    func normalize() -> [CGFloat] {
        let maxVal = self.reduce(0) { max($0, $1) } // could be self.maxElement()!
        return self.map { $0 / maxVal }
    }
}

extension CGRect {
    //Split a source rectangle into two separate rectangles at a point that is a certain ratio distance along a given edge
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divide(length * ratio, fromEdge: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .MaxXEdge || self == .MinXEdge;
    }
}


func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}
func /(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}
func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}
func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}
func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGVector {
    var point: CGPoint { return CGPoint(x: dx, y: dy) }
    var size: CGSize { return CGSize(width: dx, height: dy) }
}


//These are the three types of things we can draw
public enum Primitive {
    case Ellipse
    case Rectangle
    case Text(String)
}

//A system for constructing Diagrams: Diagrams chain together, and describe primitives and their properties.
public indirect enum Diagram {
    case Prim(CGSize, Primitive)
    case Beside(Diagram, Diagram)
    case Below(Diagram, Diagram)
    case Attributed(Attribute, Diagram)  //The Attribute is always a color (in this implementation); see below
    case Align(CGVector, Diagram)
    /*
    ^ The Align vector indicates position on a simple grid starting from the lower left corner,
    with 3 divisions per axis: (top, middle, bottom) and (left, center, right).
    
    0,1     .5,1       1,1
    0,.5    .5,.5       1,.5
    0,0     .5,0        1,0
    */
}

public enum Attribute {
    case FillColor(NSColor)
}

extension Diagram {
    //How to get a Diagram's size. For each case, we are pulling out the Diagram, until we either 1.) drill down to the related primitive, which has a size, or 2.) collect all the size data for Below or Beside cases, at which point we return the total size.
    var size: CGSize {
        switch self {
        case .Prim(let size, _):
            return size
        case .Attributed(_, let x):
            return x.size
        case .Beside(let l, let r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSizeMake(sizeL.width + sizeR.width,
                max(sizeL.height, sizeR.height))
        case .Below(let l, let r):    //Would have made more sense to use "top" and "bottom," but nooo.
            return CGSizeMake(max(l.size.width, r.size.width),
                l.size.height + r.size.height)
        case .Align(_, let r):
            return r.size
        }
    }
}

public extension CGSize {
    /*
    Rescale a "drawing" rectangle (which, in practice, is a Diagram's bounding box) so that it can be fully inscribed inside a "canvas" rectangle.
    The drawing is positioned with a vector such that a 0 value moves the drawing all the way left/down, and a 1 value moves the drawing all the way right/up, so that the appropriate edge of the drawing is flush with the edge of the canvas.
    In other words, positioning is done by the edges rather than the center, so the drawing never goes out of frame.
    */
    func fit(vector: CGVector, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)
        return CGRect(origin: rect.origin - space.point, size: size)
    }
    
}


extension CGContextRef {
    func draw(bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
            
            // Primitives
            // Primitives are always centered in their bounds. By the time you get to drawing a primitive,
            // any bounds shifting to change their alignment wil have already taken place.
        case .Prim(let size, .Ellipse):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContextFillEllipseInRect(self, frame)
            
        case .Prim(let size, .Rectangle):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContextFillRect(self, frame)
            
        case .Prim(let size, .Text(let text)):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            let font = NSFont.systemFontOfSize(12)
            let attributes = [NSFontAttributeName: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.drawInRect(frame)
            
            // Attributed
        case .Attributed(.FillColor(let color), let d): // d should be diagram
            CGContextSaveGState(self) // graphics contexts work like a stack. If we push to the stack by saving here...
            color.set() // ...and then modify the context here...
            draw(bounds, d)
            CGContextRestoreGState(self) // ...and then restore the state here, the modifications are undone.
            // Note: you can save as many times as you want; it just keeps pushing new states to the stack.
            
            // Horizontal Attachment of diagrams to each other
            // We split the canvas into two chunks based on the width of the left sub-Diagram relative to the whole Diagram
        case .Beside(let left, let right):
            let (lFrame, rFrame) = bounds.split(
                left.size.width / diagram.size.width, edge: .MinXEdge) // left.width / right.width == ratio for split
            draw(lFrame, left)
            draw(rFrame, right)
            
            // Vertical Attachment of diagrams to each other
            // Same splitting logic, applied vertically
        case .Below(let top, let bottom):
            let (lFrame, rFrame) = bounds.split( // should be topFrame, bottomFrame
                bottom.size.height / diagram.size.height, edge: .MinYEdge)
            draw(lFrame, bottom)
            draw(rFrame, top)
            
            // Alignment
            // Find the largest possible bounding box, within a canvas, in which to draw a shape.
            // Also position the box inside the canvas in accordance with the alignment vector.
            // See note on Align(CGVector, Diagram)
        case .Align(let vec, let diagram):
            let frame = diagram.size.fit(vec, bounds)
            draw(frame, diagram)
        }
    }
}

//We wrote the Draw class ourselves
public class Draw: NSView { // Draw is a bad name. Should be DrawView or similar.
    let diagram: Diagram
    
    public init(frame frameRect: NSRect, diagram: Diagram) {
        self.diagram = diagram
        super.init(frame:frameRect)
    }
    
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.currentContext() else { return }
        
        CGContextSaveGState(context.cgContext)
        
        NSColor.orangeColor().setStroke()
        CGContextSetLineWidth(context.cgContext, 2)
        CGContextStrokeRect(context.cgContext, self.bounds)
        
        CGContextRestoreGState(context.cgContext)
        
        context.cgContext.draw(self.bounds, diagram)
    }
}


extension Diagram {
    // From the book's sample code
    func pdf(width: CGFloat) -> NSData {
        let height = width * (size.height / size.width)
        let v = Draw(frame: NSMakeRect(0, 0, width, height), diagram: self)
        return v.dataWithPDFInsideRect(v.bounds)
    }
}


public func rect(width width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSizeMake(width, height), .Rectangle)
}

public func circle(diameter diameter: CGFloat) -> Diagram {
    return .Prim(CGSizeMake(diameter, diameter), .Ellipse)
}

// An ellipse(width: CGSize, height: CGSize) -> Diagram function would be useful

public func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSizeMake(width, height), .Text(theText))
}

//The reason for having a separate function for squares is that people forget that squares are rectangles.
public func square(side side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

// horizontal alignment
infix operator ||| { associativity left }
public func ||| (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Beside(l, r)
}

// vertical alignment
infix operator --- { associativity left } // ≡ could be a good alternative symbol, although it's impossible to type
public func --- (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Below(l, r)
}

public extension Diagram {
    func fill(color: NSColor) -> Diagram {
        return .Attributed(.FillColor(color), self)
    }
    
    func alignTop() -> Diagram {
        return .Align(CGVector(dx: 0.5, dy: 1), self)
    }
    
    func alignBottom() -> Diagram {
        return .Align(CGVector(dx: 0.5, dy: 0), self)
    }
    
    // no alignCenter, because it's the default
    
    // no alignLeft or alignRight - these could be added
}

func empty() -> Diagram {
    return rect(width: 0, height: 0)
}

public func hcat(diagrams: [Diagram]) -> Diagram {
    return diagrams.reduce(empty(), combine: |||)
}

// We have added vcat for the vertical arrangement of diagrams.
// They imply that such a thing follows, but they didn't actually write it.

public func vcat(diagrams: [Diagram]) -> Diagram{
    return diagrams.reduce(empty(), combine: ---)
}

// could modify this to make the bars different colors
public func barGraph(input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map { CGFloat($0.1) }
    let nValues = values.normalize()
    let bars = hcat(nValues.map { (x: CGFloat) -> Diagram in
        return rect(width: 1, height: 3 * x) .fill(.blackColor()).alignBottom()
        })
    let labels = hcat(input.map { x in
        return text(x.0, width: 1, height: 0.3).alignTop()
        })
    return bars --- labels
}