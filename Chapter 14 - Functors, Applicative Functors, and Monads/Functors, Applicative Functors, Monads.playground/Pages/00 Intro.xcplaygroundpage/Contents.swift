/*: 
 # Chapter 14:
 ## Functors, Applicative Functors, and Monads
 
 I'm paraphrasing from a great article on [mokacoding][moka] which in turn
 is a Swift interpreation of a [Haskell explanation][haskell].

 [moka]: http://www.mokacoding.com/blog/functor-applicative-monads-in-pictures/
 [haskell]: http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html

 These are all terms and common patterns from functional programming.
 
 ## Functor
 
 1. A type that implements `map`.
 
 2. A type that takes a value wrapped in a context and a transform, then returns the transformed value wrapped in the same context.

 ## Applicative Functor
 
 1. A type that takes a value wrapped in a context, and a transform wrapped in the same type of context, unwraps both, and applies the transform if both exist, then wraps the transformed value back up in the original context.
 2. Not part of the Swift standard library, so there isn't a swift function to describe it. In Haskell it's a type that implements `apply`.

 ## Monad
 
 1. A type that implements `flatMap`

 2. A type that can take a transform for an unwrapped value, and return the transformed value unwrapped from the inner context _if possible_
 
 So with that covered, lets look at some examples.

 [Next](@next)
*/
