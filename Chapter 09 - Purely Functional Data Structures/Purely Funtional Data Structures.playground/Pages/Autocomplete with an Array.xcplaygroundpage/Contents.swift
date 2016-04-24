//: [Previous](@previous)

//: ## Implementing autocomplete with an array backing the data

public struct ArrayAutocomplete {

    private var history = [String]()

    public init(){
    }

}

extension ArrayAutocomplete: Autocomplete {

    public func autoComplete(textEntered: String) -> [String] {
        return history.filter { str in
            str.lowercaseString.hasPrefix(textEntered)
        }.sort()
    }

    public mutating func addToHistory(string:String) {
        let str = string.lowercaseString
        guard !history.contains(str) && !str.isEmpty else {
            return
        }
        history.append(str)
    }

    public func elements() -> [String] {
        return history.sort()
    }
}

//: As with setLike, simple to implement, but it's not optimized for large data set.

//: [Next](@next)
