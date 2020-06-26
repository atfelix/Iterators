/// A sequence of non-overlapping substrings separated by breaks determined
/// by `isSeparator`.  This sequence keeps empty substrings.
public struct LazySplitKeepingStringSequence {
    internal let base: String
    internal let isSeparator: (String.Element) -> Bool
}

extension LazySplitKeepingStringSequence {
    /// An iterator traversing `base` and return substrings separated by `isSeparator`
    public struct Iterator {
        internal var base: String.Iterator
        internal var current: String.Element? = nil
        internal let isSeparator: (String.Element) -> Bool
    }
}

extension LazySplitKeepingStringSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public mutating func next() -> Substring? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitKeepingStringSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitKeepingStringSequence
}

extension LazySequenceProtocol where Elements == String {
    /// Returns a `LazySplitKeepingStringSequence` of substrings
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the sequences should split
    public func splitKeepingEmptySubsequences(
        isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitKeepingStringSequence {
        LazySplitKeepingStringSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }

    /// Returns a `LazySplitKeepingSequence` of substrings
    ///
    /// - Parameter separator:
    ///     An `String.Element` indicating when the substring should split
    public func splitKeepingEmptySubsequences(
        separator: String.Element
    ) -> LazySplitKeepingStringSequence {
        LazySplitKeepingStringSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
