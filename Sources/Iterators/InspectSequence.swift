/// A sequence that does not change the base sequence but evaluates a
/// function on the elements produced by the sequence
public struct InspectSequence<Base: Sequence> {
    internal let base: Base
    internal let closure: (Base.Element) -> Void
}

extension InspectSequence {
    /// An iterator that evaluates a function on each non-`nil` element
    /// produced by the iterator
    public struct Iterator {
        internal var base: Base.Iterator
        internal let closure: (Base.Element) -> Void
    }
}

extension InspectSequence.Iterator: IteratorProtocol {
    public mutating func next() -> Base.Element? {
        guard let next = base.next() else { return nil }
        closure(next)
        return next
    }
}

extension InspectSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), closure: closure)
    }
}

extension InspectSequence: LazySequenceProtocol {}

extension Sequence {
    /// Returns a sequence that evaluates a function on each element
    /// produced by `self`
    ///
    /// - Parameter closure: A function of type `(Self.Element) -> Void`
    ///
    /// - Usage:
    ///
    /// ```swift
    /// (1 ... 6)
    ///     .inspect { print("passed to filter", $0) }
    ///     .filter { $0.isMultiple(of: 3)
    ///     .inspect { print("passed to map", $0) }
    ///     .map(String.init)
    /// ```
    ///
    /// prints
    ///
    /// ```
    /// passed to filter 1
    /// passed to filter 2
    /// passed to filter 3
    /// passed to map 3
    /// passed to filter 4
    /// passed to filter 5
    /// passed to filter 6
    /// passed to map 6
    /// ```
    public func inspect(
        _ closure: @escaping (Self.Element) -> Void
    ) -> InspectSequence<Self> {
        InspectSequence(base: self, closure: closure)
    }
}
