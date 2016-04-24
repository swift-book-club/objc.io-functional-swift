import Foundation

import Foundation

private struct Trie<Element: Hashable> {
    var isElement: Bool
    var children:[Element: Trie<Element>]
}

extension Trie {
    init() {
        isElement = false
        children = [:]
    }

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

extension Array {
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}

extension Trie {
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else { return isElement }
        guard let subTrie = children[head] else { return false }
        return subTrie.lookup(tail)
    }

    func withPrefix(prefix: [Element]) -> Trie<Element>? {
        guard let (head, tail) = prefix.decompose else { return self }
        guard let remainder = children[head] else { return nil }
        return remainder.withPrefix(tail)
    }
}

extension Trie {

    init(_ key: [Element]){
        if let (head, tail) = key.decompose {
            isElement = false
            children = [head: Trie(tail)]
        }else {
            isElement = true
            children = [:]
        }
    }

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

public struct AutocompleteTries {
    private var trie = Trie<Character>()

    public init() {
    }
}

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
