struct LazyWindowCollection<Base: Collection> {
    let base: Base
    let size: Int

    init?(base: Base, size: Int) {
        guard 0 < size && size <= base.count else { return nil }
        self.base = base
        self.size = size
    }
}

extension LazyWindowCollection: Collection {
    typealias Index = Base.Index

    var startIndex: Base.Index { base.startIndex }
    var endIndex: Base.Index {
        base.index(base.endIndex, offsetBy: -(size - 1))
    }

    subscript(position: Index) -> Base.SubSequence {
        let endIndex = base.index(position, offsetBy: size, limitedBy: base.endIndex) ?? base.endIndex
        return base[position ..< endIndex]
    }

    func index(after i: Base.Index) -> Base.Index {
        guard let _ = base.index(i, offsetBy: size, limitedBy: base.endIndex) else { return endIndex }
        return base.index(after: i)
    }
}

extension LazyWindowCollection: BidirectionalCollection where Base: BidirectionalCollection {
    func index(before i: Base.Index) -> Base.Index {
        base.index(before: i)
    }
}

extension LazyWindowCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension LazyCollectionProtocol {
    func windows(
        of size: Int
    ) -> LazyWindowCollection<Elements>? {
        LazyWindowCollection(base: elements, size: size)
    }
}
