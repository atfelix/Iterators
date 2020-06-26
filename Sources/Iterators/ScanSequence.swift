/// A sequence that maintains state while iterating over a base sequence
public struct ScanSequence<Base: Sequence, State, A> {
    internal let base: Base
    internal let state: State
    internal let transform: (inout State, Base.Element) -> A?
}

extension ScanSequence {
    /// An iterator that maintains state while iterator over a base iterator
    public struct Iterator {
        internal var base: Base.Iterator
        internal var state: State
        internal let transform: (inout State, Base.Element) -> A?
    }
}

extension ScanSequence.Iterator: IteratorProtocol {
    public mutating func next() -> A? {
        guard let next = base.next() else { return nil }
        return transform(&state, next)
    }
}

extension ScanSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            state: state,
            transform: transform
        )
    }
}

extension Sequence {
    /// Returns a `ScanSequence` that maintains state while iterating over `self`'s elements
    ///
    /// - Parameter state:
    ///     An initial state that is mutated by by `transform`
    /// - Parameter transform:
    ///     A transform from a mutable state and `Self.Element` to an optional return type
    public func scan<State, A>(
        into state: State,
        _ transform: @escaping (inout State, Self.Element) -> A?
    ) -> ScanSequence<Self, State, A> {
        ScanSequence(
            base: self,
            state: state,
            transform: transform
        )
    }
}
