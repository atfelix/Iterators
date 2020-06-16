struct LazySplitKeepingSequence<Base: Sequence> {
    let base: Base
    let isSeparator: (Base.Element) -> Bool
}

extension LazySplitKeepingSequence {
    struct Iterator {
        var base: Base.Iterator
        var current: Base.Element? = nil
        let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitKeepingSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        var result: [Base.Element]? = nil
        let previous = self.current
        self.current = base.next()
        if previous == nil && self.current == nil {
            return nil
        }
        while let current = self.current, !isSeparator(current) {
            if result == nil {
                result = []
            }
            result?.append(current)
            self.current = base.next()
        }
        return result ?? []
    }
}

extension LazySplitKeepingSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitKeepingSequence: LazySequenceProtocol {
    typealias Elements = LazySplitKeepingSequence
}

extension LazySequenceProtocol {
    func splitKeeping(
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitKeepingSequence<Elements> {
        LazySplitKeepingSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    func splitKeeping(
        separator: Elements.Element
    ) -> LazySplitKeepingSequence<Elements> {
        LazySplitKeepingSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
