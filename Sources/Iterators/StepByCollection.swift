/// A collection which yields the first element in chunks of `stepSize` elements
public struct StepByCollection<Base: Collection> {
    internal let base: Base
    internal let stepSize: Int
    internal let readFirstIndex: Bool = false

    internal init(base: Base, stepSize: Int) {
        precondition(stepSize > 0)
        self.base = base
        self.stepSize = stepSize
    }
}

extension StepByCollection: Collection {
    public typealias Index = Base.Index
    public var startIndex: Index { base.startIndex }
    public var endIndex: Index { base.endIndex }

    public subscript(position: Index) -> Base.Element {
        base[position]
    }

    /// - Note:
    ///     This algorithm is _O(1)_ only if the base collection
    ///     conforms to `RandomAccessCollection`
    public func index(after i: Index) -> Index {
        base.index(i, offsetBy: stepSize, limitedBy: endIndex) ?? endIndex
    }
}

extension StepByCollection: BidirectionalCollection where Base: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        base.index(i, offsetBy: -stepSize, limitedBy: startIndex) ?? startIndex
    }
}

extension StepByCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension StepByCollection: LazyCollectionProtocol {}

extension Collection {
    /// Returns a `StepByCollection`
    ///
    /// - Parameter size: The step size
    public func stepBy(
        size: Int
    ) -> StepByCollection<Self> {
        StepByCollection(base: self, stepSize: size)
    }
}

extension LazyCollectionProtocol {
    /// Returns a `StepByCollection`
    ///
    /// - Parameter size: The step size
    public func stepBy(
        size: Int
    ) -> StepByCollection<Elements> {
        StepByCollection(base: elements, stepSize: size)
    }
}
