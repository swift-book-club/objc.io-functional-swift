/*:
 [Previous](@previous)

 ## Applicative Functors
 
 ## Applicative Functor

 1. A type that takes a value wrapped in a context, and a transform wrapped in the same type of context, unwraps both, and applies the transform if both exist, then wraps the transformed value back up in the original context.
 2. Not part of the Swift standard library, so there isn't a swift function to describe it. In Haskell it's a type that implements `apply`.

*/
import Foundation

//: Since the standard library doesn't implement these, we need to write apply for any types that we want to use it with

//: For an optional, apply takes an optional value, and an optional function and returns an optional result

extension Optional {
    func apply<U>(f: (Wrapped -> U)?) -> U? {
        switch f {
        case .Some(let someF): return self.map(someF)
        case .None: return .None
        }
    }
}

let optionalNumber: Int? = 5

let emptyOptionalNumber: Int? = nil

let optionalFunction: ((Int) -> Int)? = { int in
    return int * 2
}

let emptyOptionalFunction: ((Int) -> Int)? = nil

//: All non-nil gets a result
let nonNil = optionalNumber.apply(optionalFunction)

print(nonNil, terminator: "")

//: Empty value and full function returns nil

let nil1 = emptyOptionalNumber.apply(optionalFunction)

//: Filled value and empty function returns nil

let nil2 = optionalNumber.apply(emptyOptionalFunction)

//: Empty value and empty function returns nil

let nil3 = emptyOptionalNumber.apply(emptyOptionalFunction)

//: For an array, apply takes an array of transforms and applies each transform to each element in the array and returns a new array containing all of the transformed values

extension Array {
    func apply<U>(transforms: [Element -> U]) -> [U] {
        var result = [U]()
        for t in transforms {
            result += self.map(t)
        }
        return result
    }
}

let values: [Int] = [1, 2, 3, 4, 5]

let transforms:[(Int) -> Int] = [
    { $0 + 1 },
    { $0 * 5 },
    { $0 * $0 },
]

let results = values.apply(transforms)

//: The new array is values * transforms long

results.count

let noForms:[(Int) -> Int] = []

values.apply(noForms)
//: Applying an empty array of tranforms means you get back an empty array (values * 0 long) 

//: [Next](@next)
