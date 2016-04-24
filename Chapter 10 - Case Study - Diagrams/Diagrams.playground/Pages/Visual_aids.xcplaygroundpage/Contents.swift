//: [The code](@previous)

import Cocoa

var str = "Hello, playground"

// <ugh> -----------------------------------------------------------
//For no damn reason at all, operators can't go in a source file

// horizontal alignment
infix operator ||| { associativity left }

// vertical alignment
infix operator --- { associativity left }

// </ugh> ----------------------------------------------------------



let cities = [
    "Shanghai": 14.01,
    "Istanbul": 13.3,
    "Moscow": 10.56,
    "New York": 8.33,
    "Berlin": 3.43
]

//Bring in example 3 from the book
let example3 = barGraph(Array(cities))

//Our own modification to make the bars different colors.
/*
Lots of ways to associate a repeating list of colors with data.
We chose to simply set the draw color at each iteration of the map.
*/
let myBarColors = [NSColor.redColor() , .orangeColor() , .yellowColor() , .greenColor(), .blueColor(), .purpleColor()]

func colorBarGraph(input: [(String, Double)], barcolors: [NSColor]) -> Diagram {
    let values: [CGFloat] = input.map { CGFloat($0.1) }
    let nValues = values.normalize()
    var colorcounter = 0
    let bars = hcat(nValues.map { (x: CGFloat) -> Diagram in
        let myreturn = rect(width: 1, height: 3 * x) .fill(myBarColors[colorcounter]).alignBottom()
        //This could easily be done with an ever-increasing number and a modulus, instead.
        //A number with a controlled bound feels safer to me because my background is in C.
        colorcounter = (colorcounter < (myBarColors.count - 1)) ? colorcounter + 1 : 0
        return myreturn
        })
    let labels = hcat(input.map { x in
        return text(x.0, width: 1, height: 0.3).alignTop()
        })
    return bars --- labels
}

let example3andahalf = colorBarGraph(Array(cities), barcolors: myBarColors)

let barGraphComparison = Draw(frame: NSMakeRect(0, 0, 400, 600), diagram: example3 --- example3andahalf)

//: [Next](@next)
