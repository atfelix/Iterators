/// A sequence of non-overlapping substrings separated by breaks determined
/// by `isSeparator`.  This sequence omits empty substrings.
public struct LazySplitOmittingStringSequence {
    internal let base: String
    internal let isSeparator: (String.Element) -> Bool
}

extension LazySplitOmittingStringSequence {
    /// An iterator traversing `base` and return substrings separated by `isSeparator`
    public struct Iterator {
        internal var base: String.Iterator
        internal var current: String.Element? = nil
        internal let isSeparator: (String.Element) -> Bool
    }
}

extension LazySplitOmittingStringSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public mutating func next() -> Substring? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitOmittingStringSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitOmittingStringSequence
}

extension LazySequenceProtocol where Elements == String {
    /// Returns a `LazySplitOmittingStringSequence` of substrings
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the sequences should split
    public func splitOmittingEmptySequences(
        _ isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitOmittingStringSequence {
        LazySplitOmittingStringSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }

    /// Returns a `LazySplitOmittingSequence` of substrings
    ///
    /// - Parameter separator:
    ///     An `String.Element` indicating when the substring should split
    public func splitOmittingEmptySequences(
        separator: Elements.Element
    ) -> LazySplitOmittingStringSequence {
        LazySplitOmittingStringSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
