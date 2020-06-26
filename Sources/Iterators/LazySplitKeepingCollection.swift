/// A collection of subsequences separator by into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  This collection keeps empty
/// subsequences.
public struct LazySplitKeepingCollection<Base: Collection> {
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

extension LazySplitKeepingCollection: Collection {
    public var startIndex: Index { .index(base.startIndex) }
    public var endIndex: Index { .ended }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public subscript(position: Index) -> Base.SubSequence {
        guard let index = position.index,
            index != base.endIndex
            else { return base[base.endIndex ..< base.endIndex] }

        let separator = base[index...].firstIndex(where: isSeparator)
        return base[index ..< (separator ?? base.endIndex)]
    }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public func index(after i: Index) -> Index {
        guard let index = i.index,
            index != base.endIndex,
            let separator = base[index...].firstIndex(where: isSeparator)
        else { return endIndex }

        return .index(base.index(after: separator))
    }
}

extension LazySplitKeepingCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        guard let index = i.index else { return endIndex }
        let reversed = base[..<base.index(before: index)].reversed()
        let separator = reversed.firstIndex(where: isSeparator)
        return .index(separator?.base ?? base.startIndex)
    }
}

extension LazySplitKeepingCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a `LazySplitKeepingCollection` of `elements`
    ///
    /// - Parameter isSeparator:
    ///     A predicate indicating when the subsequences should split
    public func splitKeepingEmptySubsequences(
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitKeepingCollection<Elements> {
        LazySplitKeepingCollection(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazyCollectionProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitKeepingCollection` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the subsequences should split
    public func splitKeepingEmptySubsequences(
        separator: Elements.Element
    ) -> LazySplitKeepingCollection<Elements> {
        LazySplitKeepingCollection(
            base: elements,
            isSeparator:  { $0 == separator }
        )
    }
}

