struct LazyChunkingCollection<Base: Collection> {
    let base: Base
    let size: Int
    let exact: Bool
}

extension LazyChunkingCollection: Collection {
    typealias Index = Base.Index

    var startIndex: Base.Index { base.startIndex }
    var endIndex: Base.Index { base.endIndex }

    subscript(position: Base.Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        let distance = base.distance(from: position, to: nextIndex)

        if exact, !distance.isMultiple(of: size) {
            return base[position ..< position]
        }
        else {
            return base[position ..< nextIndex]
        }
    }

    func index(after i: Base.Index) -> Base.Index {
        base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
    }
}

extension LazyChunkingCollection: BidirectionalCollection where Base: BidirectionalCollection {
    func index(before i: Base.Index) -> Base.Index {
        let offset = i == endIndex ? base.count % size + 1 : size
        return base.index(i, offsetBy: -offset, limitedBy: startIndex) ?? startIndex
    }
}

extension LazyChunkingCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyChunkingCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    func chunks(
        of size: Int,
        exact: Bool = false
    ) -> LazyChunkingCollection<Elements> {
        LazyChunkingCollection(base: elements, size: size, exact: exact)
    }
}
