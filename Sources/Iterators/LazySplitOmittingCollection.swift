/// A collection of subsequences separated into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  This collection omits empty
/// subsequences.
public struct LazySplitOmittingCollection<Base: Collection> {
    public enum Index: Comparable {
        case index(Base.Index)
        case ended

        var index: Base.Index? {
            switch self {
            case let .index(index):
                return index
            case .ended:
                return nil
            }
        }

        public static func < (lhs: Index, rhs: Index) -> Bool {
            switch (lhs, rhs) {
            case let (.index(left), .index(right)):
                return left < right
            case (.index, .ended):
                return true
            default:
                return false
            }
        }
    }

    internal let base: Base
    internal let isSeparator: (Base.Element) -> Bool
}

extension LazySplitOmittingCollection: Collection {
    public var startIndex: Index {
        var index = base.startIndex
        while index < base.endIndex, isSeparator(base[index]) {
            base.formIndex(after: &index)
        }
        return .index(index)
    }
    public var endIndex: Index { .ended }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.

    public subscript(position: Index) -> Base.SubSequence {
        guard let index = position.index else { return base[base.endIndex ..< base.endIndex] }

        guard let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator)
            else { return base[index ..< base.endIndex] }

        return base[index ..< nextSeparatorIndex]
    }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public func index(after i: Index) -> Index {
        guard let index = i.index,
            let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator),
            let nextNotSeparatorIndex = base[nextSeparatorIndex...].firstIndex(where: { !isSeparator($0) })
            else { return endIndex }
        return .index(nextNotSeparatorIndex)
    }
}

extension LazySplitOmittingCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        guard let index = i.index else { return endIndex }
        let reversed = base[..<base.index(before: index)].reversed()
        let separator = reversed.firstIndex(where: isSeparator)
        return .index(separator?.base ?? base.startIndex)
    }
}

extension LazySplitOmittingCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a `LazySplitOmittingCollection` of `elements`
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the subsequences should split
    public func splitOmittingEmptySubsequences(
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitOmittingCollection<Elements> {
        LazySplitOmittingCollection(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazyCollectionProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitOmittingCollection` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the subsequences should split
    public func splitOmittingEmptySubsequences(
        separator: Elements.Element
    ) -> LazySplitOmittingCollection<Elements> {
        LazySplitOmittingCollection(
            base: elements,
            isSeparator:  { $0 == separator }
        )
    }
}
