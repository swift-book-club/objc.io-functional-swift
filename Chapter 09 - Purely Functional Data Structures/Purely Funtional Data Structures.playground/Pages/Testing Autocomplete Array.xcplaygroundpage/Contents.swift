//: [Previous](@previous)

//: ## Testing out the Autocomplete array

import Foundation

var autocompleteBuffer = ArrayAutocomplete()

for word in "'We have no future because our present is too volatile. We have only risk management. The spinning of the given moment's scenarios. Pattern recognition.'― William Gibson, Pattern Recognition".componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet) {
    autocompleteBuffer.addToHistory(word)
}

autocompleteBuffer.elements()

autocompleteBuffer.autoComplete("t")

autocompleteBuffer.autoComplete("w")

autocompleteBuffer.autoComplete("p")

autocompleteBuffer.autoComplete("pa")

//: [Next](@next)
