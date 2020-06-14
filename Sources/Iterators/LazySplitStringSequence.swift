struct LazySplitStringSequence {
    let base: String
    let omittingEmptySubsequences: Bool
    let isSeparator: (String.Element) -> Bool
}

extension LazySplitStringSequence {
    struct Iterator {
        var base: String.Iterator
        var current: String.Element? = nil
        let omittingEmptySubsequences: Bool
        let isSeparator: (String.Element) -> Bool

        init(
            base: String.Iterator,
            omittingEmptySubsequences: Bool,
            isSeparator: @escaping (String.Element) -> Bool
        ) {
            self.base = base
            self.omittingEmptySubsequences = omittingEmptySubsequences
            self.isSeparator = isSeparator
        }
    }
}

extension LazySplitStringSequence.Iterator: IteratorProtocol {
    mutating func next() -> Substring? {
        if omittingEmptySubsequences {
            var result: Substring? = nil
            self.current = base.next()
            while let _current = self.current, isSeparator(_current) {
                self.current = base.next()
            }
            while let _current = self.current, !isSeparator(_current) {
                if result == nil {
                    result = Substring()
                }
                result?.append(_current)
                self.current = base.next()
            }
            return result
        }
        else {
            var result: Substring? = nil
            let previous = self.current
            self.current = base.next()
            if previous == nil && self.current == nil {
                return nil
            }
            while let _current = self.current, !isSeparator(_current) {
                if result == nil {
                    result = Substring()
                }
                result?.append(_current)
                self.current = base.next()
            }

            return result ?? Substring()
        }
    }
}

extension LazySplitStringSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

extension LazySplitStringSequence: LazySequenceProtocol {
    typealias Elements = LazySplitStringSequence
}

extension LazySequenceProtocol where Elements == String {
    func split(
        separator: String.Element,
        omittingEmptySubsequences: Bool
    ) -> LazySplitStringSequence {
        LazySplitStringSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: { $0 == separator }
        )
    }
}
