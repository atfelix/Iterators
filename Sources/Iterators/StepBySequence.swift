struct StepBySequence<Base: Sequence> {
    let base: Base
    let stepSize: UInt

    init(base: Base, stepSize: UInt) {
        precondition(stepSize > 0)
        self.base = base
        self.stepSize = stepSize
    }
}

extension StepBySequence {
    struct Iterator {
        var base: Base.Iterator
        var current: Base.Element?
        let stepSize: UInt

        init(base: Base.Iterator, stepSize: UInt) {
            precondition(stepSize > 0)
            self.base = base
            self.stepSize = stepSize
        }
    }
}

extension StepBySequence.Iterator: IteratorProtocol {
    mutating func next() -> Base.Element? {
        guard let first = base.next() else { return nil }
        (0 ..< (stepSize - 1)).forEach { _ in _ = base.next() }
        return first
    }
}

extension StepBySequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), stepSize: stepSize)
    }
}

extension Sequence {
    func stepBy(size: UInt) -> StepBySequence<Self> {
        precondition(size > 0)
        return StepBySequence(base: self, stepSize: size)
    }
}
