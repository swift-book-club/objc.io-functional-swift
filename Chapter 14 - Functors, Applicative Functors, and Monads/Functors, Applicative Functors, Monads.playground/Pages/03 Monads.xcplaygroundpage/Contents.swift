/*:
 [Previous](@previous)

 ## Monads
 
 1. A type that implements `flatMap`

 2. A type that can take a transform for an unwrapped value, and return the transformed value unwrapped from the inner context _if possible_

*/

import Foundation

let optionalInt: Int? = 6

func onlyEven(int: Int) -> Int? {
    return int % 2 == 0 ? int : nil
}

let doubleOptional = optionalInt.map(onlyEven)

print(doubleOptional, terminator: "")

//: Because `onlyEven` returns an optional value, we end up with a double optional, which isn't ideal
let singleOptional = optionalInt.flatMap(onlyEven)

print(singleOptional, terminator: "")
//: FlatMap unwraps the internal optional, keeping it as a single `?`

func double(int: Int) -> Int {
    return int * 2
}

//: FlatMap removes the inner optional context

print(optionalInt.map(double), terminator: "")
print(optionalInt.flatMap(double), terminator: "")

//: `flatMap` acts just like `map` for transforms that don't include a context


func expand(number: Int) -> [Int] {
    return Array(0...number)
}

let a = optionalInt.map(expand)

let b = optionalInt.flatMap(expand)

//: If the inner context can't be unpacked into the outer context, `flatMap` and `map` also act the same

let array = [1, 2, 3, 4, 5, 6]

array.map(onlyEven)
//: Map makes an [Int?]

array.flatMap(onlyEven)
//: FlatMap unpacks that to [Int] and discards the empty optionals

array.map(expand)

//: Map makes [[Int]]

array.flatMap(expand)

//: FlatMap unpacks the inner array to make makes [Int]
