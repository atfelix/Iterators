/// A sequence of arrays separated into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  This sequence omits empty
/// subsequences.
public struct LazySplitOmittingSequence<Base: Sequence> {
    internal let base: Base
    internal let isSeparator: (Base.Element) -> Bool
}

extension LazySplitOmittingSequence {
    /// An iterator traversing `base` and return arrays of elements separated by `isSeparator`
    public struct Iterator {
        internal var base: Base.Iterator
        internal var current: Base.Element? = nil
        internal let isSeparator: (Base.Element) -> Bool
    }
}

extension LazySplitOmittingSequence.Iterator: IteratorProtocol {
    /// - Complexity:
    ///     _O(k)_ where `k` is the number of elements that return `false` from `isSeparator`.
    public mutating func next() -> [Base.Element]? {
        var result: [Base.Element]? = nil
        self.current = base.next()
        while let current = self.current, isSeparator(current) {
            self.current = base.next()
        }
        while let current = self.current, !isSeparator(current) {
            if result == nil {
                result = []
            }
            result?.append(current)
            self.current = base.next()
        }
        return result
    }
}

extension LazySplitOmittingSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            isSeparator: isSeparator
        )
    }
}

extension LazySplitOmittingSequence: LazySequenceProtocol {
    public typealias Elements = LazySplitOmittingSequence
}

extension LazySequenceProtocol {
    /// Returns a `LazySplitOmittingSequence` of `elements`
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the sequences should split
    public func splitOmittingEmptySequences(
        _ isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitOmittingSequence<Elements> {
        LazySplitOmittingSequence(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazySequenceProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitOmittingSequence` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the sequences should split
    public func splitOmittingEmptySequences(
        separator: Elements.Element
    ) -> LazySplitOmittingSequence<Elements> {
        LazySplitOmittingSequence(
            base: elements,
            isSeparator: { $0 == separator }
        )
    }
}
