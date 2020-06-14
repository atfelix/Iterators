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
    var startIndex: Index { .index(base.startIndex) }
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
                else { return .ended } //.index(base.endIndex) }

            let x = base.index(after: separator)
            return .index(x)
        }
    }
}

extension LazyCollectionProtocol where Elements == String {
    func split(separator: Element) -> LazySplitStringCollection {
        return LazySplitStringCollection(base: elements, omittingEmptySubsequences: false) { $0 == separator }
    }
}
