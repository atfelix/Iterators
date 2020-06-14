struct LazySplitSequence<Base: Sequence> {
    let base: Base
    let omittingEmptySubsequences: Bool
    let isSeparator: (Base.Element) -> Bool
}

extension LazySplitSequence {
    struct Iterator {
        var base: Base.Iterator
        var current: Base.Element? = nil
        let omittingEmptySubsequences: Bool
        let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        if omittingEmptySubsequences {
            var result: [Base.Element]? = nil
            self.current = base.next()
            while let _current = self.current, isSeparator(_current) {
                self.current = base.next()
            }
            while let _current = self.current, !isSeparator(_current) {
                if result == nil {
                    result = []
                }
                result?.append(_current)
                self.current = base.next()
            }
            return result
        }
        else {
            var result: [Base.Element]? = nil
            let previous = self.current
            self.current = base.next()
            if previous == nil && self.current == nil {
                return nil
            }
            while let _current = self.current, !isSeparator(_current) {
                if result == nil {
                    result = []
                }
                result?.append(_current)
                self.current = base.next()
            }
            return result ?? []
        }
    }
}

extension LazySplitSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

extension LazySplitSequence: LazySequenceProtocol {
    typealias Elements = LazySplitSequence
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    func split(
        separator: Elements.Element,
        omittingEmptySequences: Bool
    ) -> LazySplitSequence<Elements> {
        LazySplitSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySequences,
            isSeparator:  { $0 == separator }
        )
    }

    func split(
        omittingEmptySequences: Bool = true,
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitSequence<Elements> {
        LazySplitSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySequences,
            isSeparator: isSeparator
        )
    }
}
