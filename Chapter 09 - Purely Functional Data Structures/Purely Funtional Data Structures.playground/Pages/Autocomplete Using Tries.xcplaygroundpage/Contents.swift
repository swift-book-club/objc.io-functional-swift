//: [Previous](@previous)

//: ## Autocomplete using Tries

//: Tries are similar to binary search trees, but they allow for an arbitrary number of children. For string lookup, each node contains the next potential branches

import Foundation

private struct Trie<Element: Hashable> {
    // Used to determine if the current string is within the trie
    var isElement: Bool
    // Stores the next layer of branches on the Trie
    var children:[Element: Trie<Element>]
}

extension Trie {
    // Convenience initializer for an empty trie
    init() {
        isElement = false
        children = [:]
    }

    // Recursively walks down the trie and assembles all of the elements that it contains
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map {
                [key] + $0
            }
        }
        return result
    }
}

// Makes it easier iterate through the contents of an array
extension RangeReplaceableCollectionType {
    var decompose: (Self.Generator.Element, Self)? {
        guard !isEmpty else {
            return nil
        }
        var copy = self
        return (copy.removeFirst(), copy)
    }
}

extension Trie {
    // Steps through each element in the key until the entire key is matched, or the key can no longer be matched
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else { return isElement }
        guard let subTrie = children[head] else { return false }
        return subTrie.lookup(tail)
    }

    // Shows all elements stored in the trie that contain a given prefix
    func withPrefix(prefix: [Element]) -> Trie<Element>? {
        guard let (head, tail) = prefix.decompose else { return self }
        guard let remainder = children[head] else { return nil }
        return remainder.withPrefix(tail)
    }
}

extension Trie {

    // Allows quick initialization from an array of elements
    init(_ key: [Element]){
        if let (head, tail) = key.decompose {
            isElement = false
            children = [head: Trie(tail)]
        }else {
            isElement = true
            children = [:]
        }
    }

    // Inserts a new key into the trie
    mutating func insert(key: [Element]) {
        guard let (head, tail) = key.decompose else {
            self.isElement = true
            return
        }
        if children.keys.contains(head) {
            children[head]?.insert(tail)
        } else {
            children[head] = Trie(tail)
        }
    }

}

//: A wrapper struct around the Trie elements
public struct AutocompleteTries {

    private var trie = Trie<Character>()

    public init() {
    }

}

//: Adds Autocomplete conformance to the struct
extension AutocompleteTries: Autocomplete {

    // Finds all suffixes matching the current entered text, and then returns the assembled words
    public func autoComplete(textEntered: String) -> [String] {
        let char = Array(textEntered.characters)
        guard let suffixes = trie.withPrefix(char)?.elements else {
            return []
        }
        let words = suffixes.map { chars in
            return textEntered + String(chars)
        }
        return words.sort()
    }

    // Adds a new string to the trie
    public mutating func addToHistory(string:String) {
        guard !string.isEmpty else {
            return
        }
        trie.insert(Array(string.localizedLowercaseString.characters))
    }

    // Gathers all of the elements in the trie, converts them to strings and sorts them
    public func elements() -> [String] {
        return trie.elements.map({ String($0) }).sort() ?? []
    }

}

//: [Next](@next)
