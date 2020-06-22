/// A lazy collection which produces non-overlapping chunks with `size`
/// elements of the base collection.  If the last chunk has fewer than
///  `size` elements, it is not produced by this collection.
public struct LazyChunkingExactCollection<Base: Collection> {
    internal let base: Base
    internal let size: Int
}

extension LazyChunkingExactCollection: Collection {
    public typealias Index = Base.Index

    public var startIndex: Index { base.startIndex }
    public var endIndex: Index { base.endIndex }

    public subscript(position: Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        let distance = base.distance(from: position, to: nextIndex)

        if distance.isMultiple(of: size) {
            return base[position ..< nextIndex]
        }
        else {
            return base[position ..< position]
        }
    }

    public func index(after i: Index) -> Index {
        let nextIndex = base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
        let nextIndexAfter = base.index(nextIndex, offsetBy: size, limitedBy: endIndex) ?? endIndex
        return base.distance(from: nextIndex, to: nextIndexAfter) == size
            ? nextIndex
            : endIndex
    }
}

extension LazyChunkingExactCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        if i == endIndex {
            let remainder = base.count % size
            return base.index(i, offsetBy: -size - remainder, limitedBy: startIndex) ?? startIndex
        }
        else {
            return base.index(i, offsetBy: -size, limitedBy: startIndex) ?? startIndex
        }
    }
}

extension LazyChunkingExactCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyChunkingExactCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a collection that provides non-overlapping chunks of `self`
    /// where the last chunk is provided only if it has `size` elements
    ///
    /// - Parameter size: The size of the desired chunks
    public func chunkExactly(
        by size: Int
    ) -> LazyChunkingExactCollection<Elements> {
        LazyChunkingExactCollection(base: elements, size: size)
    }
}
