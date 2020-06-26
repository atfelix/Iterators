/// A collection of overlapping subsequences of size given by `size`.
public struct LazyWindowCollection<Base: Collection> {
    internal let base: Base
    internal let size: Int

    internal init(base: Base, size: Int) {
        precondition(0 < size)
        self.base = base
        self.size = size
    }
}

extension LazyWindowCollection: Collection {
    public typealias Index = Base.Index

    public var startIndex: Base.Index { base.startIndex }
    public var endIndex: Base.Index {
        base.index(base.endIndex, offsetBy: -(size - 1))
    }
    /// Return a subsequence of the base collection at the given position
    ///
    /// - Parameter position: an index of the base collection
    ///
    /// - Note:
    ///     This algorithm _O(1)_ only if the base collection conforms to
    ///     `RandomAccessCollection`
    public subscript(position: Index) -> Base.SubSequence {
        guard let endIndex = base.index(position, offsetBy: size, limitedBy: base.endIndex) else { return base[base.endIndex ..< base.endIndex] }
        return base[position ..< endIndex]
    }

    public func index(after i: Base.Index) -> Base.Index {
        guard let _ = base.index(i, offsetBy: size, limitedBy: base.endIndex) else { return endIndex }
        return base.index(after: i)
    }
}

extension LazyWindowCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Base.Index) -> Base.Index {
        base.index(before: i)
    }
}

extension LazyWindowCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyWindowCollection: LazyCollectionProtocol {}

extension LazyCollectionProtocol {
    /// Returns a `LazyWindowCollection`
    ///
    /// - Parameter size:  The size of the windows
    public func windows(
        of size: Int
    ) -> LazyWindowCollection<Elements> {
        LazyWindowCollection(base: elements, size: size)
    }
}
