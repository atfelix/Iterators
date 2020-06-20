/// A sequence that chains two sequences with the same type of elements together
///
/// For example,
///
/// ```swift
/// let chainedIterator = (1 ... 3).chain([4, 5]).makeIterator()
///
/// chainedIterator.next() == 1
/// chainedIterator.next() == 2
/// chainedIterator.next() == 3
/// chainedIterator.next() == 4
/// chainedIterator.next() == 5
/// chainedIterator.next() == nil
/// ```
public struct ChainSequence<Base1: Sequence, Base2: Sequence> where Base1.Element == Base2.Element {
    internal let base1: Base1
    internal let base2: Base2
}

extension ChainSequence {
    /// This iterator provides the elements from `base1` first and then moves to `base2`'s elements
    public struct Iterator {
        internal var base1: Base1.Iterator
        internal var base2: Base2.Iterator
    }
}

extension ChainSequence.Iterator: IteratorProtocol {
    public mutating func next() -> Base1.Element? {
        base1.next() ?? base2.next()
    }
}

extension ChainSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(base1: base1.makeIterator(), base2: base2.makeIterator())
    }
}

extension ChainSequence: LazySequenceProtocol {}

extension Sequence {
    /// Returns a sequence that chains the elements of `self` and then the elements of `other`
    ///
    /// - Parameter other: A sequence of elements with type `Self.Element`
    public func chain<Other: Sequence>(
        _ other: Other
    ) -> ChainSequence<Self, Other> where Self.Element == Other.Element {
        ChainSequence(base1: self, base2: other)
    }
}
