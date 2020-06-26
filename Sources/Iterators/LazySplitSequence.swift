/// A sequence of arrays separated into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  This sequence omits empty
/// subsequences if and only if `omittingEmptySubsequences` is `true`.
public struct LazySplitSequence<Base: Sequence> {
    internal let base: Base
    internal let omittingEmptySubsequences: Bool
    internal let isSeparator: (Base.Element) -> Bool
}

extension LazySplitSequence {
    /// An iterator traversing `base` and return arrays of elements separated by `isSeparator`
    public struct Iterator {
        internal var base: Base.Iterator
        internal var current: Base.Element? = nil
        internal let omittingEmptySubsequences: Bool
        internal let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of elements that return `false` from `isSeparator`.
    public mutating func next() -> [Base.Element]? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

extension LazySplitSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitSequence
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitSequence` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the sequences should split
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` indicating whether empty subsequences should be omitted
    public func split(
        separator: Elements.Element,
        omittingEmptySubsequences: Bool
    ) -> LazySplitSequence<Elements> {
        LazySplitSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator:  { $0 == separator }
        )
    }
}

extension LazySequenceProtocol {
    /// Returns a `LazySplitSequence` of `elements`
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the sequences should split
    /// - Parameter omittingEmptySubsequences:
    ///     AA `Bool` indicating whether empty subsequences should be omitted
    public func split(
        omittingEmptySubsequences: Bool = true,
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitSequence<Elements> {
        LazySplitSequence(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}
