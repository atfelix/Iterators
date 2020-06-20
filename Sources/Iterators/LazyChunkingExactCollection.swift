struct LazyChunkingExactCollection<Base: Collection> {
    let base: Base
    let size: Int
}

extension LazyChunkingExactCollection: Collection {
    typealias Index = Base.Index

    var startIndex: Base.Index { base.startIndex }
    var endIndex: Base.Index { base.endIndex }

    subscript(position: Base.Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        let distance = base.distance(from: position, to: nextIndex)

        if distance.isMultiple(of: size) {
            return base[position ..< nextIndex]
        }
        else {
            return base[position ..< position]
        }
    }

    func index(after i: Base.Index) -> Base.Index {
        base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
    }
}

extension LazyChunkingExactCollection: BidirectionalCollection where Base: BidirectionalCollection {
    func index(before i: Base.Index) -> Base.Index {
        let offset = i == endIndex ? base.count % size + 1 : size
        return base.index(i, offsetBy: -offset, limitedBy: startIndex) ?? startIndex
    }
}

extension LazyChunkingExactCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyChunkingExactCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    func chunkExactly(
        by size: Int
    ) -> LazyChunkingExactCollection<Elements> {
        LazyChunkingExactCollection(base: elements, size: size)
    }
}
