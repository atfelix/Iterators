struct LazySplitOmittingCollection<Base: Collection> {
    enum Index: Comparable {
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

    let base: Base
    let isSeparator: (Base.Element) -> Bool
}

extension LazySplitOmittingCollection: Collection {
    var startIndex: Index { .index(base.startIndex) }
    var endIndex: Index { .ended }

    subscript(position: Index) -> Base.SubSequence {
        guard let index = position.index else { return base[base.endIndex ..< base.endIndex] }

        guard let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator)
            else { return base[index ..< base.endIndex] }

        return base[index ..< nextSeparatorIndex]
    }

    func index(after i: Index) -> Index {
        guard let index = i.index,
            let nextSeparatorIndex = base[index...].firstIndex(where: isSeparator),
            let nextNotSeparatorIndex = base[nextSeparatorIndex...].firstIndex(where: { !isSeparator($0) })
            else { return endIndex }
        return .index(nextNotSeparatorIndex)
    }
}

extension LazySplitOmittingCollection: BidirectionalCollection where Base: BidirectionalCollection {
    func index(before i: Index) -> Index {
        guard let index = i.index else { return endIndex }
        let reversed = base[..<base.index(before: index)].reversed()
        let separator = reversed.firstIndex(where: isSeparator)
        return .index(separator?.base ?? base.startIndex)
    }
}

extension LazyCollectionProtocol {
    func splitOmitting(
        isSeparator: @escaping (Elements.Element) -> Bool
    ) -> LazySplitOmittingCollection<Elements> {
        LazySplitOmittingCollection(
            base: elements,
            isSeparator: isSeparator
        )
    }
}

extension LazyCollectionProtocol where Elements.Element: Equatable {
    func splitOmitting(
        separator: Elements.Element
    ) -> LazySplitOmittingCollection<Elements> {
        LazySplitOmittingCollection(
            base: elements,
            isSeparator:  { $0 == separator }
        )
    }
}

