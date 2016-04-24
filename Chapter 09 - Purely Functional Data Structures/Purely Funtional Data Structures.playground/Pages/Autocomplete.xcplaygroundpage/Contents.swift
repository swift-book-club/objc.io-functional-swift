//: [Previous](@previous)

//: # Implementing Autocomplete

//: This defines the required functionality for our Autocomplete implementations

public protocol Autocomplete {

    // Returns possible matches for a given string
    func autoComplete(textEntered: String) -> [String]

    // Adds a new string to the autocomplete history
    mutating func addToHistory(string:String)

    // Displays all of the elements currently stored in the autocomplete buffer
    func elements() -> [String]

}


//: [Next](@next)
