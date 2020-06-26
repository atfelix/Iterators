/// A collection of subsequences separator by into non-overlapping subsequences
/// where breaks are determined by `isSeparator`.  These subsequences will
/// omit empty subsequences if and only if `omittingEmptySubsequences` is `true`.
public struct LazySplitCollection<Base: Collection> {
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
    internal let omittingEmptySubsequences: Bool
    internal let isSeparator: (Base.Element) -> Bool
}

extension LazySplitCollection: Collection {
    public var startIndex: Index {
        if omittingEmptySubsequences {
            var index = base.startIndex
            while index < base.endIndex, isSeparator(base[index]) {
                base.formIndex(after: &index)
            }
            return .index(index)
        }
        else {
            return .index(base.startIndex)
        }
    }
    public var endIndex: Index { .ended }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public subscript(position: Index) -> Base.SubSequence {
        guard let index = position.index else { return base[base.endIndex ..< base.endIndex] }

        if !omittingEmptySubsequences && index == base.endIndex {
            return base[base.endIndex ..< base.endIndex]
        }

        if omittingEmptySubsequences {
            guard let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator)
                else { return base[index ..< base.endIndex] }

            return base[index ..< nextSeparatorIndex]
        }
        else {
            let separator = base[index...].firstIndex(where: isSeparator)
            return base[index ..< (separator ?? base.endIndex)]
        }
    }

    /// - Complexity:
    ///     _O(k)_ where `k` is the number of characters that return `false` from `isSeparator`.
    public func index(after i: Index) -> Index {
        guard let index = i.index else { return endIndex }

        if !omittingEmptySubsequences && index == base.endIndex {
            return endIndex
        }

        if omittingEmptySubsequences {
            guard let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator),
                let nextNotSeparatorIndex = base[nextSeparatorIndex...].firstIndex(where: { !isSeparator($0) })
                else { return endIndex }

            return .index(nextNotSeparatorIndex)
        }
        else {
            guard let separator = base[index...].firstIndex(where: isSeparator)
                else { return endIndex }
            return .index(base.index(after: separator))
        }
    }
}

extension LazySplitCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        guard let index = i.index else { return endIndex }
        let reversed = base[..<base.index(before: index)].reversed()
        let separator = reversed.firstIndex(where: isSeparator)
        return .index(separator?.base ?? base.startIndex)
    }
}

extension LazySplitCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a `LazySplitCollection` of `elements`
    ///
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` which indicates whether empty sequences should be omitted or not
    /// - Parameter isSeparator:
    ///     A predicate indicating when the subsequences should split
    public func split(
        omittingEmptySubsequences: Bool = true,
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitCollection<Elements> {
        LazySplitCollection(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

extension LazyCollectionProtocol where Elements.Element: Equatable {
    /// Returns a `LazySplitCollection` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Elements.Element` indicating when the subsequences should split
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` which indicates whether empty sequences should be omitted or not
    public func split(
        separator: Elements.Element,
        omittingEmptySubsequences: Bool = true
    ) -> LazySplitCollection<Elements> {
        LazySplitCollection(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator:  { $0 == separator }
        )
    }
}
