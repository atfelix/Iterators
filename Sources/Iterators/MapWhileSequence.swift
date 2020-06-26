/// A sequence that maps the base elements using `transform` and stops
/// when the transform returns `nil`.
public struct MapWhileSequence<Base: Sequence, A> {
    internal let base: Base
    internal let transform: (Base.Element) -> A?
}

extension MapWhileSequence {
    /// An iterator that provides mapped elements until it provides `nil`
    public struct Iterator {
        internal var base: Base.Iterator
        internal let transform: (Base.Element) -> A?
    }
}

extension MapWhileSequence.Iterator: IteratorProtocol {
    public mutating func next() -> A? {
        base.next().flatMap(transform)
    }
}

extension MapWhileSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), transform: transform)
    }
}

extension MapWhileSequence: LazySequenceProtocol {}

extension Sequence {
    /// Returns a `MapWhileSequence`
    ///
    /// - Parameter transform:
    ///     A transformation that maps `Self.Element` to an A?
    ///
    /// - Note:
    ///     The transform will be called _n + 1_ times where
    ///     _n_ is the number of elements that return non-optional
    ///     values.
    public func mapWhile<A>(
        _ transform: @escaping (Self.Element) -> A?
    ) -> MapWhileSequence<Self, A> {
        MapWhileSequence(base: self, transform: transform)
    }
}
