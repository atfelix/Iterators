/// A collection of substrings separated into non-overlapping substrings
/// where breaks are determined by `isSeparator`.  This collection omits empty
/// subsequences if and only if `omittingEmptySubsequences` is `true`.
public struct LazySplitStringCollection {
    public enum Index: Comparable {
        case index(String.Index)
        case ended

        internal var index: String.Index? {
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

    internal let base: String
    internal let omittingEmptySubsequences: Bool
    internal let isSeparator: (String.Element) -> Bool
}

extension LazySplitStringCollection: Collection {
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
    public subscript(position: Index) -> Substring {
        guard let index = position.index else { return base[base.endIndex ..< base.endIndex] }
        if !omittingEmptySubsequences && position.index == base.endIndex {
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
        guard let index = i.index else { return .ended }

        if !omittingEmptySubsequences && index == base.endIndex {
            return .ended
        }

        if omittingEmptySubsequences {
            guard let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator),
                let nextNotSeparatorIndex = base[nextSeparatorIndex...].firstIndex(where: { !isSeparator($0) })
                else { return endIndex }

            return .index(nextNotSeparatorIndex)
        }
        else {
            guard let separator = base[index...].firstIndex(where: isSeparator)
                else { return .ended }

            return .index(base.index(after: separator))
        }
    }
}

extension LazySplitStringCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol where Elements == String {
    /// Returns a `LazySplitStringCollection` of `elements`
    ///
    /// - Parameter separator:
    ///     An `Element` indicating when the string should split
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` which indicates whether empty sequences should be omitted or not
    public func split(
        separator: Element,
        omittingEmptySubsequences: Bool = false
    ) -> LazySplitStringCollection {
        LazySplitStringCollection(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: { $0 == separator }
        )
    }

    /// Returns a `LazySplitStringCollection` of `elements`
    ///
    /// - Parameter omittingEmptySubsequences:
    ///     A `Bool` which indicates whether empty substrings should be omitted or not
    /// - Parameter isSeparator:
    ///     A predicate indicating when the string should split
    public func split(
        omittingEmptySubsequences: Bool = false,
        isSeparator: @escaping (String.Element) -> Bool
    ) -> LazySplitStringCollection {
        LazySplitStringCollection(
            base: elements,
            omittingEmptySubsequences: omittingEmptySubsequences,
            isSeparator: isSeparator
        )
    }
}

