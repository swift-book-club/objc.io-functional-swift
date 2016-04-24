//: [Previous](@previous)

//: ## Testing out the SetLike Array

//: Creating an empty SetLike array
var binaryArray: ArraySet<Int> = ArraySet.empty()

binaryArray.isEmpty()

//: Inserting a new object into the array
binaryArray.insert(1)

binaryArray.isEmpty()

let archive = binaryArray

binaryArray.insert(2)

//: copies don't mutate when the original changes
archive.includes(2)

binaryArray.includes(2)

//: [Next](@next)
