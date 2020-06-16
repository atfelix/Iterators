# Todo iterators and sequences

- Add chunking exact collection instead of using conditional logic
- Add chunking exact sequence instead of using conditional logic
- Add windowing exact collection instead of using conditional logic
- Add windowing exact sequence instead of using conditional logic
- Consider adding the following sequences / collections / iterators that [rust](https://doc.rust-lang.org/std/iter/trait.Iterator.html):
  - [`chain`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.chain)
  - [`cycle`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.cycle): This one may already be implemented in Swift under `repeatElement` and `Repeated`, but the composition with it is not ideal given how Swift composes elements. See [Repeat.swift](https://github.com/apple/swift/blob/master/stdlib/public/core/Repeat.swift)
  - [`inspect`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.inspect)
  - [`map_while`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map_while)
  - [`peekable`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.peekable)
  - [`scan`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.scan)
  - [`step_by`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.step_by)
  - [`unzip`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.unzip)
- Consider adding some of the string iterators that Rust has as well
