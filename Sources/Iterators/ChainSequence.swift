struct ChainSequence<Base1: Sequence, Base2: Sequence> where Base1.Element == Base2.Element {
    let base1: Base1
    let base2: Base2
}

extension ChainSequence {
    struct Iterator {
        var base1: Base1.Iterator
        var base2: Base2.Iterator
    }
}

extension ChainSequence.Iterator: IteratorProtocol {
    mutating func next() -> Base1.Element? {
        base1.next() ?? base2.next()
    }
}

extension ChainSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base1: base1.makeIterator(), base2: base2.makeIterator())
    }
}

extension Sequence {
    func chain<Other: Sequence>(
        other: Other
    ) -> ChainSequence<Self, Other> where Self.Element == Other.Element {
        ChainSequence(base1: self, base2: other)
    }
}
