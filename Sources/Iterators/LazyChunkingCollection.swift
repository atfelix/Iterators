/// A collection of non-overlapping subsequences of size given by `size`
/// and will not include the final subsequence if `exact` is `true` and the final
/// subsequence fewer than `size` elements
public struct LazyChunkingCollection<Base: Collection> {
    internal let base: Base
    internal let size: Int
    internal let exact: Bool
}

extension LazyChunkingCollection: Collection {
    public typealias Index = Base.Index

    public var startIndex: Index { base.startIndex }
    public var endIndex: Index { base.endIndex }

    /// Return a subsequence of the base collection at the given position
    ///
    /// - Parameter position: an index of the base collection
    ///
    /// - Note:
    ///     This algorithm _O(1)_ only if the base collection conforms to
    ///     `RandomAccessCollection`
    public subscript(position: Index) -> Base.SubSequence {
        let nextIndex = base.index(position, offsetBy: size, limitedBy: endIndex) ?? endIndex
        let distance = base.distance(from: position, to: nextIndex)

        if exact, !distance.isMultiple(of: size) {
            return base[position ..< position]
        }
        else {
            return base[position ..< nextIndex]
        }
    }

    public func index(after i: Index) -> Index {
        if exact {
            let nextIndex = base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
            let nextIndexAfter = base.index(nextIndex, offsetBy: size, limitedBy: endIndex) ?? endIndex
            return base.distance(from: nextIndex, to: nextIndexAfter) == size
                ? nextIndex
                : endIndex
        }
        else {
            return base.index(i, offsetBy: size, limitedBy: endIndex) ?? endIndex
        }
    }
}

extension LazyChunkingCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        switch (exact, i == endIndex) {
        case (true, true):
            let remainder = base.count % size
            return base.index(i, offsetBy: -size - remainder, limitedBy: startIndex) ?? startIndex
        case (false, true):
            let remainder = base.count % size
            return base.index(i, offsetBy: remainder == 0 ? -size : -remainder, limitedBy: startIndex) ?? startIndex
        default:
            return base.index(i, offsetBy: -size, limitedBy: startIndex) ?? startIndex
        }
    }
}

extension LazyChunkingCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyChunkingCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a `LazyChunkingCollection`
    ///
    /// - Parameter size:  The size of the chunks
    /// - Parameter exact:
    ///     The boolean indicating whether or not to include the last subsequence
    ///     when it doesn't contain `size` elements
    ///
    public func chunks(
        of size: Int,
        exact: Bool = false
    ) -> LazyChunkingCollection<Elements> {
        LazyChunkingCollection(base: elements, size: size, exact: exact)
    }
}
