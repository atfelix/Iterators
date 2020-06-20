# Iterators

This package provides several helpful sequences, collections, iterators and a few algorithms for Swift.  These types are inspired by [#SR-6867](https://bugs.swift.org/browse/SR-6867), [#SR-6864](https://bugs.swift.org/browse/SR-6864), [#SR-6691](https://bugs.swift.org/browse/SR-6691) and many [Rust iterators](https://doc.rust-lang.org/std/iter/trait.Iterator.html)

## `chain`

```swift
Array((1 ... 4).chain([5, 6, 7])) == [1, 2, 3, 4, 5, 6, 7]
```

## `chunks` 

```swift
Array([1, 2, 3, 4, 5, 6, 7, 8].chunks(of: 3, exact: true)) == [[1, 2, 3], [4, 5, 6]]
Array([1, 2, 3, 4, 5, 6, 7, 8].chunks(of: 3, exact: false)) == [[1, 2, 3], [4, 5, 6], [7, 8]]
Array([1, 2, 3, 4, 5, 6, 7, 8].chunkExactly(by: 3)) == [[1, 2, 3], [4, 5, 6]]
Array([1, 2, 3, 4, 5, 6, 7, 8].chunkInexactly(by: 3)) == [[1, 2, 3], [4, 5, 6], [7, 8]]
```

`chunks` also works on lazy sequences and lazy collections

## `cycled`

```swift
let cycle = sequence(first: 1) { $0 == 10 ? nil : $0 + 1 }
    .cycled()
    .prefix(20)
XCTAssertEqual([1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10], Array(cycle))
```

## `inspect`

```swift
var outputs: [Int] = []
let seq = [1, 2, 3, 4, 5, 6, 7, 8, 9 ,10]
    .inspect { outputs.append($0) }
    _ = Array(seq)
    XCTAssertEqual([1,2,3,4,5,6,7,8,9,10], outputs)
```

## `split`

We also provide lazy sequences and collections with split functionality.  There are two ways using it:  the `split` API from the standard library on collections and sequences

```swift
Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false)) == ["", "", "", "ab", "cdef", "", "", "ghi", "", "", "j", "", "", "k", "", "lm", "", "n", "", "", ""]
Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true)) == ["ab", "cdef", "ghi", "j", "k", "lm", "n"]
```

or (using less dynamic approach)

```swift
Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: ".")) == ["", "", "", "ab", "cdef", "", "", "ghi", "", "", "j", "", "", "k", "", "lm", "", "n", "", "", ""]
Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySubsequences(separator: ".")) == ["ab", "cdef", "ghi", "j", "k", "lm", "n"]
```

## `windows`

```swift
(1 ... 5).windows(of: 3)?.map(Array.init) == [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
```

## `mapWhile`

```swift
(["1", "2", "3", "four", "5", "6", "seven", "7"]).mapWhile(Int.init) == [1, 2, 3]
```

## `peeking`

Peeking only applies to iterators.  It turns an iterator into an iterator that can peek:

```swift
var iterator = [1,2,3].makeIterator().peekable()
XCTAssertEqual(1, iterator.peek())
XCTAssertEqual(2, iterator.next())
XCTAssertEqual(1, iterator.next())
XCTAssertEqual(3, iterator.peek())
XCTAssertEqual(3, iterator.peek())
XCTAssertEqual(3, iterator.next())
XCTAssertEqual(nil, iterator.peek())
XCTAssertEqual(nil, iterator.next())
```

## `repeatedForever`

The `repeatedForever` function is like the `repeatedElement` function but without the integer limit on the number of times the element can repeat.

```swift
Array(repeatForever(element: 1).prefix(5)) == [1,1,1,1,1]
```

## `scan`

```swift
let array = [1,2,3].scan(into: 1) { state, int -> Int? in
    state *= int
    return .some(-state)
}
let a = Array(array)
var iterator = array.makeIterator()
XCTAssertEqual(iterator.next(), -1)
XCTAssertEqual(iterator.next(), -2)
XCTAssertEqual(iterator.next(), -6)
XCTAssertEqual(iterator.next(), nil)
XCTAssertEqual([-1, -2, -6], a)
```

## `stepBy`

```swift
Array([0, 1, 2, 3, 4, 5].stepBy(size: 2) == [0, 2, 4]
```
