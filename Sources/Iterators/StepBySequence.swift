/// A sequence which yields the first element in windows of `stepSize` gaps
public struct StepBySequence<Base: Sequence> {
    internal let base: Base
    internal let stepSize: Int

    internal init(base: Base, stepSize: Int) {
        precondition(stepSize > 0)
        self.base = base
        self.stepSize = stepSize
    }
}

extension StepBySequence {
    /// An iterator which yields the first element in windows of `stepSize` gaps
    public struct Iterator {
        internal var base: Base.Iterator
        internal var current: Base.Element?
        internal let stepSize: Int

        internal init(base: Base.Iterator, stepSize: Int) {
            precondition(stepSize > 0)
            self.base = base
            self.stepSize = stepSize
        }
    }
}

extension StepBySequence.Iterator: IteratorProtocol {
    public mutating func next() -> Base.Element? {
        guard let first = base.next() else { return nil }
        (0 ..< (stepSize - 1)).forEach { _ in _ = base.next() }
        return first
    }
}

extension StepBySequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), stepSize: stepSize)
    }
}

extension StepBySequence: LazySequenceProtocol {}

extension Sequence {
    /// Returns a `StepBySequence`
    ///
    /// - Parameter size: The step size 
    public func stepBy(size: Int) -> StepBySequence<Self> {
        precondition(size > 0)
        return StepBySequence(base: self, stepSize: size)
    }
}
