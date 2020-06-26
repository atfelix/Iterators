/// A sequence of arrays separated into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  This sequence keeps empty
/// subsequences.
public struct LazySplitKeepingSequence<Base: Sequence> {
    internal let base: Base
    internal let isSeparator: (Base.Element) -> Bool
}

extension LazySplitKeepingSequence {
    /// An iterator traversing `base` and return arrays of elements separated by `isSeparator`
    public struct Iterator {
        internal var base: Base.Iterator
        internal var current: Base.Element? = nil
        internal let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitKeepingSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of elements that return `false` from `isSeparator`.
    public mutating func next() -> [Base.Element]? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitKeepingSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitKeepingSequence
}

extension LazySequenceProtocol {
    /// Returns a `LazySplitKeepingSequence` of `elements`
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the sequences should split
    public func splitKeepingEmptySubsequences(
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitKeepingSequence<Elements> {
        LazySplitKeepingSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitKeepingSequence` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the sequences should split
    public func splitKeepingEmptySubsequences(
        separator: Elements.Element
    ) -> LazySplitKeepingSequence<Elements> {
        LazySplitKeepingSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
