struct LazySplitStringCollection {
    enum Index: Comparable {
        case index(String.Index)
        case ended

        var index: String.Index? {
            switch self {
            case let .index(index):
                return index
            case .ended:
                return nil
            }
        }

        static func < (lhs: Index, rhs: Index) -> Bool {
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

    let base: String
    let omittingEmptySubsequences: Bool
    let isSeparator: (String.Element) -> Bool
}

extension LazySplitStringCollection: Collection {
    var startIndex: Index {
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
    var endIndex: Index { .ended }

    /// Not _O(1)_
    subscript(position: Index) -> Substring {
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

    func index(after i: Index) -> Index {
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
    func split(
        separator: Element,
        omittingEmptySequences: Bool = false
    ) -> LazySplitStringCollection {
        LazySplitStringCollection(
            base: elements,
            omittingEmptySubsequences: false,
            isSeparator: { $0 == separator }
        )
    }

    func split(
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

