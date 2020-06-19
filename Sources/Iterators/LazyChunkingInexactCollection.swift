struct LazyChunkingInexactCollection<Base: Collection> {
    let base: Base
    let size: Int
}

extension LazyChunkingInexactCollection: Collection {
    typealias Index = Base.Index

    var startIndex: Index { base.startIndex }
    var endIndex: Index { base.endIndex}

    subscript(position: Base.Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        return base[position ..< nextIndex]
    }

    func index(after i: Base.Index) -> Base.Index {
        base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
    }
}

extension LazyChunkingInexactCollection: BidirectionalCollection where Base: BidirectionalCollection {
    func index(before i: Index) -> Index {
        let offset = i == endIndex ? base.count % size + 1 : size
        return base.index(i, offsetBy: -offset, limitedBy: startIndex) ?? startIndex
    }
}

extension LazyChunkingInexactCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyCollectionProtocol {
    func chunksInexactly(
        by size: Int
    ) -> LazyChunkingInexactCollection<Elements> {
        LazyChunkingInexactCollection(base: elements, size: size)
    }
}
