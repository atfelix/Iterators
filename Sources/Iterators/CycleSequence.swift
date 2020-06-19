struct CycleSequence<Base: Sequence> {
    let base: Base
}

extension CycleSequence {
    struct Iterator {
        var base: Base.Iterator
        let originalIterator: Base.Iterator

        init(base: Base.Iterator) {
            self.base = base
            self.originalIterator = base
        }
    }
}

extension CycleSequence.Iterator: IteratorProtocol {
    mutating func next() -> Base.Element? {
        guard let next = base.next() else {
            base = originalIterator
            return base.next()
        }

        return next
    }
}

extension CycleSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator())
    }
}

extension Sequence {
    func cycled() -> CycleSequence<Self> {
        CycleSequence(base: self)
    }
}
