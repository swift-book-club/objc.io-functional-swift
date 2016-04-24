import Cocoa

// <ugh> -----------------------------------------------------------
//For no damn reason at all, operators can't go in a source file

// horizontal alignment
infix operator ||| { associativity left }

// vertical alignment
infix operator --- { associativity left }

// </ugh> ----------------------------------------------------------


//:## Example Tiiiiiiime

//Test the Fit function

CGSize(width: 1, height: 1).fit(
    CGVector(dx: 1, dy: 0.5), CGRect(x: 0, y: 0, width: 200, height: 100))

CGSize(width: 1, height: 1).fit(
    CGVector(dx: 0, dy: 0.5), CGRect(x: 0, y: 0, width: 200, height: 100))

//Visulaizations of examples from the book

let blueSquare = square(side: 1).fill(.blueColor())
let redSquare = square(side: 2).fill(.redColor())
let greenCircle = circle(diameter: 1).fill(.greenColor())
let example1 = blueSquare ||| redSquare ||| greenCircle


let view1 = Draw(frame: NSMakeRect(0, 0, 300, 200), diagram: example1)

let cyanCircle = circle(diameter: 1).fill(.cyanColor())
let example2 = blueSquare ||| cyanCircle ||| redSquare ||| greenCircle

let view2 = Draw(frame: NSMakeRect(0, 0, 300, 200), diagram: example2)

let cities = [
    "Shanghai": 14.01,
    "Istanbul": 13.3,
    "Moscow": 10.56,
    "New York": 8.33,
    "Berlin": 3.43
]

let example3 = barGraph(Array(cities))

//Note that if the rectangle is wider than 450, there is a bug with the bar height!
let view3 = Draw(frame: NSMakeRect(0, 0, 500, 300), diagram: example3)

let view4 = Draw(frame: NSMakeRect(0, 0, 300, 200), diagram: blueSquare ||| redSquare)

let view5 = Draw(frame: NSMakeRect(0, 0, 300, 200), diagram: .Align(CGVector(dx: 0.5, dy: 1), blueSquare) ||| redSquare)

