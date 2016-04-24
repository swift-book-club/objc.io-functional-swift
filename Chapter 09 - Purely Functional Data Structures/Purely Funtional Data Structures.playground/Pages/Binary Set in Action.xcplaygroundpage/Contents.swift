//: [Previous](@previous)
//: # Testing out the BinarySet

//: Make a new empty tree
var binaryTree: BinarySet<Int> = BinarySet.empty()

binaryTree.elements()

binaryTree.isEmpty()

//: Insert an item into the tree
binaryTree.insert(1)

binaryTree.elements()

binaryTree.isEmpty()

//: Make a copy that won't be hit by future changes

let archive = binaryTree

binaryTree.insert(3)

binaryTree.elements()

//: Proving that the tree doesn't insert the same value multiple times

binaryTree.insert(2)

binaryTree.insert(2)

binaryTree.insert(2)

//: The content always comes out sorted
archive.elements()

binaryTree.elements()

archive.includes(2)

binaryTree.includes(2)

//: [Next](@next)
