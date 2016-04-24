public protocol Autocomplete {

    func autoComplete(textEntered: String) -> [String]

    mutating func addToHistory(string:String)

    func elements() -> [String]

}