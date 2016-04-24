//: # Purely Functional Data Structures

//: ## Implementing your own Set-Like data

//: To make it easier to compare the two implementations, I've defined a protcol.

public protocol SetLike {

    associatedtype Element: Equatable

    // Returns an empty set
    static func empty() -> Self

    // Checks whether or not a set is empty
    func isEmpty() -> Bool

    // Checks whether or not an element is in a set
    func includes(element: Self.Element) -> Bool

    // Adds an element to an existing set, if it doesn't already exist
    mutating func insert(element: Self.Element)

    // Returns all elements stored in the set
    func elements() -> [Self.Element]
    
}

//: [Next](@next)
