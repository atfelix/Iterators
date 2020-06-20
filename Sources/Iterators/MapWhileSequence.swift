struct MapWhileSequence<Base: Sequence, A> {
    let base: Base
    let transform: (Base.Element) -> A?
}

extension MapWhileSequence {
    struct Iterator {
        var base: Base.Iterator
        let transform: (Base.Element) -> A?
    }
}

extension MapWhileSequence.Iterator: IteratorProtocol {
    mutating func next() -> A? {
        base.next().flatMap(transform)
    }
}

extension MapWhileSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), transform: transform)
    }
}

extension MapWhileSequence: LazySequenceProtocol {}

extension Sequence {
    func mapWhile<A>(
        _ transform: @escaping (Self.Element) -> A?
    ) -> MapWhileSequence<Self, A> {
        MapWhileSequence(base: self, transform: transform)
    }
}
