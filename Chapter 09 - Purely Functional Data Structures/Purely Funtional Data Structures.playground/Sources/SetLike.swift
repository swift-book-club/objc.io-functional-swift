public protocol SetLike {

    associatedtype Element

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