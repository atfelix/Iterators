struct ScanSequence<Base: Sequence, State, A> {
    let base: Base
    var state: State
    let transform: (inout State, Base.Element) -> A?
}

extension ScanSequence {
    struct Iterator {
        var base: Base.Iterator
        var state: State
        let transform: (inout State, Base.Element) -> A?
    }
}

extension ScanSequence.Iterator: IteratorProtocol {
    mutating func next() -> A? {
        guard let next = base.next() else { return nil }
        return transform(&state, next)
    }
}

extension ScanSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            state: state,
            transform: transform
        )
    }
}

extension Sequence {
    func scan<State, A>(
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
