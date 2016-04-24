//: [Previous](@previous)

//:## Implementing SetLike with a binary tree

//: The binary search tree storage structure, swift requires an indirect case even though the reference to BinarySet is hidden inside the NodeContent struct
public enum BinarySet<Element: Comparable> {

    case Leaf
    indirect case Node(NodeContent<Element>)

}

//: This was written to avoid having to write: `case let .Node(left, center, right)` repeatedly, has the added benefit of making it harder to rearrange the data because the struct is publicly exposed but the initializers are all internal
public struct NodeContent<Element: Comparable> {

    let left: BinarySet<Element>
    let center: Element
    let right: BinarySet<Element>

    internal init(left: BinarySet<Element> = .Leaf, center: Element, right: BinarySet<Element> = .Leaf){
        (self.left, self.center, self.right) = (left, center, right)
    }

}


//: Used to avoid having to write comparisons with spurious fall-through cases
private enum PivotDirection {
    case None, Left, Right
}

private extension Comparable {

    func pivotFrom(otherElement: Self) -> PivotDirection {
        if self < otherElement {
            return .Left
        }
        else if self > otherElement {
            return .Right
        }
        else {
            return .None
        }
    }

}

//: Convenience methods to make the internals of the BinarySet cleaner
internal extension NodeContent{

    func includesElement(element:Element) -> Bool {
        switch element.pivotFrom(center) {
        case .None:
            return true
        case .Left:
            return left.includes(element)
        case .Right:
            return right.includes(element)
        }
    }

    func nodeWithNewLeft(newLeft: BinarySet<Element>) -> NodeContent {
        return NodeContent(left: newLeft, center: center, right: right)
    }

    func nodeWithNewRight(newRight: BinarySet<Element>) -> NodeContent {
        return NodeContent(left: left, center: center, right: newRight)
    }

    func elements() -> [Element] {
        return left.elements() + [center] + right.elements()
    }

}

//: Convenience method to insert a new node into a binary set
private extension BinarySet {

    func addNode(node: Element) -> BinarySet<Element> {
        switch self{
        case .Leaf: return .Node(NodeContent(center: node))
        case let .Node(content):
            let newContent: NodeContent<Element>
            switch node.pivotFrom(content.center) {
            case .None:
                return self
            case .Left:
                newContent = content.nodeWithNewLeft(content.left.addNode(node))
            case .Right:
                newContent = content.nodeWithNewRight(content.right.addNode(node))
            }
            return BinarySet.Node(newContent)
        }
    }

}

//: Adds the Searchable protocol to the binary search tree, it's a thin wrapper around the enum to prevent direct manipulation of the tree by outside code
extension BinarySet: SetLike {

    public static func empty() -> BinarySet {
        return .Leaf
    }

    // Leaves are empty, everything else is non-empty
    public func isEmpty() -> Bool {
        switch self {
        case .Leaf: return true
        case .Node: return false
        }
    }

    // Recursively walks the tree to determine if it includes the element
    public func includes(element: Element) -> Bool {
        switch self{
        case .Leaf:
            return false
        case let .Node(content):
            return content.includesElement(element)
        }
    }

    // If self is a leaf, replace self with a new node with the element at the center
    // otherwise add the element to the node
    public mutating func insert(element: Element) {
        switch self{
        case .Leaf:
            self = .Node(NodeContent(center: element))
        case .Node:
            self = addNode(element)
        }
    }

    // Recursively gathers all of the elements in the tree
    public func elements() -> [Element] {
        switch self{
        case .Leaf:
            return []
        case let .Node(content):
            return content.elements()
        }
    }
}

//: [Next](@next)
