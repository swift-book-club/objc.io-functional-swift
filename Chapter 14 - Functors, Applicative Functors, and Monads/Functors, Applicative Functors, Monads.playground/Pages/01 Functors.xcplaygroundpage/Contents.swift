/*: 
 [Previous](@previous)

 ## Functors

 1. A type that implements `map`.

 2. A type that takes a value wrapped in a context and a transform, then returns the transformed value wrapped in the same context.
*/

public protocol Squaring {
    func square<T: IntegerArithmeticType>(number: T) -> T
}

//: SquaringCounter conforms to the Squaring protocol

let counter = SquaringCounter()

let nonOptional: Int = 10

//: No need for map since this isn't stored in a context

let nonOptionalResult = counter.square(nonOptional)

print(nonOptionalResult, terminator: "")

let some: Int? = 5

//: This will generate a compiler error if uncommented
// square(some)

//: Note the lack of a `?` before the `.map`, this is mapping the optional, not the underlying value
let someResult = some.map(counter.square)

counter.runCount

print(someResult, terminator: "")

//: The value comes back as an optional

let none: Int? = nil

let noneResult = none.map(counter.square)

counter.runCount

//: Nothing in, nothing out, nothing was done

//: ### An array is a different type of context

let numbers = [1, 2, 3, 4, 5]

let newNumbers = numbers.map(counter.square)

print(newNumbers, terminator: "")

//: Each number is transformed, then placed back into the array

func oddEven(int: Int) -> String {
    return int % 2 == 0 ? "Even" : "Odd"
}

numbers.map(oddEven)

//: Transforms the numbers to a new type, and wraps them up in the array

counter.runCount

//: [Next](@next)
