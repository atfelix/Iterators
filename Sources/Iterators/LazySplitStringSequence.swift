/// A sequence of substrings separated into non-overlapping substrings
/// where breaks are determined by `isSeparator`.  This sequence omits empty
/// subsequences if and only if `omittingEmptySubsequences` is `true`.
public struct LazySplitStringSequence {
    internal let base: String
    internal let omittingEmptySubsequences: Bool
    internal let isSeparator: (String.Element) -> Bool
}

extension LazySplitStringSequence {
    /// An iterator traversing `base` and return arrays of elements separated by `isSeparator`
    public struct Iterator {
        internal var base: String.Iterator
        internal var current: String.Element? = nil
        internal let omittingEmptySubsequences: Bool
        internal let isSeparator: (String.Element) -> Bool
    }
}

extension LazySplitStringSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of elements that return `false` from `isSeparator`.
    public mutating func next() -> Substring? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

extension LazySplitStringSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitStringSequence
}

extension LazySequenceProtocol where Elements == String {
    /// Returns a `LazySplitStringSequence` of `elements`
    ///
    /// - Parameter separator:
    ///     An `String.Element` indicating when the sequences should split
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` indicating whether empty subsequences should be omitted
    public func split(
        separator: String.Element,
        omittingEmptySubsequences: Bool
    ) -> LazySplitStringSequence {
        LazySplitStringSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: { $0 == separator }
        )
    }

    /// Returns a `LazySplitStringSequence` of `elements`
    ///
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` indicating whether empty subsequences should be omitted
    /// - Parameter isSeparator:
    ///     A predicate indicating when the substrings should split
    public func split(
        omittingEmptySubsequences: Bool,
        isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitStringSequence {
        LazySplitStringSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}
