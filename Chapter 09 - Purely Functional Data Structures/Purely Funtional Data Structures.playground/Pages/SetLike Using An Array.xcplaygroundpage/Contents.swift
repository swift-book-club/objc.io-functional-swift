//: [Previous](@previous)

//: ## Implementing SetLike with an Array

//: The wrapping struct around the data storage

public struct ArraySet<Element: Equatable> {

    private var array: [Element]

    private init(e: [Element]) {
        self.array = e
    }

}

// Implementing the protocol

extension ArraySet: SetLike {

    public static func empty() -> ArraySet {
        return ArraySet<Element>(e: [])
    }

    public func isEmpty() -> Bool {
        return self.array.isEmpty
    }

    public func includes(element: Element) -> Bool {
        return self.array.contains(element)
    }

    public mutating func insert(element: Element) {
        if !self.includes(element) {
            self.array.append(element)
        }
    }

    public func elements() -> [Element] {
        return array
    }
}

//: It's easy to implement, but the performance scales linearly, so with large arrays this approach could become problematic.

//: [Next](@next)
