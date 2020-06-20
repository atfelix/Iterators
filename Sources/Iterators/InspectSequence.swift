struct InspectSequence<Base: Sequence> {
    let base: Base
    let closure: (Base.Element) -> Void
}

extension InspectSequence {
    struct Iterator {
        var base: Base.Iterator
        let closure: (Base.Element) -> Void
    }
}

extension InspectSequence.Iterator: IteratorProtocol {
    mutating func next() -> Base.Element? {
        guard let next = base.next() else { return nil }
        closure(next)
        return next
    }
}

extension InspectSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), closure: closure)
    }
}

extension InspectSequence: LazySequenceProtocol {}

extension Sequence {
    func inspect(
        _ closure: @escaping (Self.Element) -> Void
    ) -> InspectSequence<Self> {
        InspectSequence(base: self, closure: closure)
    }
}
