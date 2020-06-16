struct LazySplitOmittingStringSequence {
    let base: String
    let isSeparator: (String.Element) -> Bool
}

extension LazySplitOmittingStringSequence {
    struct Iterator {
        var base: String.Iterator
        var current: String.Element? = nil
        let isSeparator: (String.Element) -> Bool
    }
}

extension LazySplitOmittingStringSequence.Iterator: IteratorProtocol {
    mutating func next() -> Substring? {
        var result: Substring? = nil
        self.current = base.next()
        while let current = self.current, isSeparator(current) {
            self.current = base.next()
        }
        while let current = self.current, !isSeparator(current) {
            if result == nil {
                result = Substring()
            }
            result?.append(current)
            self.current = base.next()
        }
        return result
    }
}

extension LazySplitOmittingStringSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitOmittingStringSequence: LazySequenceProtocol {
    typealias Elements = LazySplitOmittingStringSequence
}

extension LazySequenceProtocol where Elements == String{
    func splitOmittingEmptySequences(
        _ isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitOmittingStringSequence {
        LazySplitOmittingStringSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }

    func splitOmittingEmptySequences(
        separator: Elements.Element
    ) -> LazySplitOmittingStringSequence {
        LazySplitOmittingStringSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
