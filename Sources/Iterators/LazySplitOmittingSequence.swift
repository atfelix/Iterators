struct LazySplitOmittingSequence<Base: Sequence> {
    let base: Base
    let isSeparator: (Base.Element) -> Bool
}

extension LazySplitOmittingSequence {
    struct Iterator {
        var base: Base.Iterator
        var current: Base.Element? = nil
        let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitOmittingSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        var result: [Base.Element]? = nil
        self.current = base.next()
        while let current = self.current, isSeparator(current) {
            self.current = base.next()
        }
        while let current = self.current, !isSeparator(current) {
            if result == nil {
                result = []
            }
            result?.append(current)
            self.current = base.next()
        }
        return result
    }
}

extension LazySplitOmittingSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitOmittingSequence: LazySequenceProtocol {
    typealias Elements = LazySplitOmittingSequence
}

extension LazySequenceProtocol {
    func splitOmittingEmptySequences(
        _ isSeparator: (Elements.Element) -> Bool
    ) -> LazySplitOmittingSequence<Elements> {
        LazySplitOmittingSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    func splitOmittingEmptySequences(
        separator: Elements.Element
    ) -> LazySplitOmittingSequence<Elements> {
        LazySplitOmittingSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
