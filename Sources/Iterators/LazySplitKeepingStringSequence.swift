struct LazySplitKeepingStringSequence {
    let base: String
    let isSeparator: (String.Element) -> Bool
}

extension LazySplitKeepingStringSequence {
    struct Iterator {
        var base: String.Iterator
        var current: String.Element? = nil
        let isSeparator: (String.Element) -> Bool
    }
}

extension LazySplitKeepingStringSequence.Iterator: IteratorProtocol {
    mutating func next() -> Substring? {
        var result: Substring? = nil
        let previous = self.current
        self.current = base.next()
        if previous == nil && self.current == nil {
            return nil
        }
        while let current = self.current, !isSeparator(current) {
            if result == nil {
                result = Substring()
            }
            result?.append(current)
            self.current = base.next()
        }
        return result ?? Substring()
    }
}

extension LazySplitKeepingStringSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitKeepingStringSequence: LazySequenceProtocol {
    typealias Elements = LazySplitKeepingStringSequence
}

extension LazySequenceProtocol where Elements == String {
    func splitKeeping(
        isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitKeepingStringSequence {
        LazySplitKeepingStringSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }

    func splitKeeping(
        separator: String.Element
    ) -> LazySplitKeepingStringSequence {
        LazySplitKeepingStringSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
