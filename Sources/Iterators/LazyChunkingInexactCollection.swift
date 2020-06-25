/// A lazy collection which produces non-overlapping chunks with `size`
/// elements of the base collection.
public struct LazyChunkingInexactCollection<Base: Collection> {
    internal let base: Base
    internal let size: Int
}

extension LazyChunkingInexactCollection: Collection {
    public typealias Index = Base.Index

    public var startIndex: Index { base.startIndex }
    public var endIndex: Index { base.endIndex}

    public subscript(position: Base.Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        return base[position ..< nextIndex]
    }

    public func index(after i: Base.Index) -> Base.Index {
        base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
    }
}

extension LazyChunkingInexactCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        if i == endIndex {
            let remainder = base.count % size
            return base.index(i, offsetBy: remainder == 0 ? -size : -remainder, limitedBy: startIndex) ?? startIndex
        }
        else {
            return base.index(i, offsetBy: -size, limitedBy: startIndex) ?? startIndex
        }
    }
}

extension LazyChunkingInexactCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyChunkingInexactCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a collection that provides non-overlapping chunks of `self`.
    ///
    /// - Parameter size: The size of the desired chunks
    public func chunkInexactly(
        by size: Int
    ) -> LazyChunkingInexactCollection<Elements> {
        LazyChunkingInexactCollection(base: elements, size: size)
    }
}
