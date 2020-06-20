/// A sequence which repeats the base sequence indefinitely
///
/// For example,
///
/// ```swift
/// let cycledIterator = (1 ... 4).cycled().makeIterator()
/// cycledIterator.next() == 1
/// cycledIterator.next() == 2
/// cycledIterator.next() == 3
/// cycledIterator.next() == 4
/// cycledIterator.next() == 1
/// cycledIterator.next() == 2
/// cycledIterator.next() == 3
/// cycledIterator.next() == 4
/// ```
///
/// and so on.
public struct CycleSequence<Base: Sequence> {
    internal let base: Base
}

extension CycleSequence {
    /// An iterator that repeats the original iterator once it has been depleted
    public struct Iterator {
        internal var base: Base.Iterator
        internal let originalIterator: Base.Iterator

        internal init(base: Base.Iterator) {
            self.base = base
            self.originalIterator = base
        }
    }
}

extension CycleSequence.Iterator: IteratorProtocol {
    public mutating func next() -> Base.Element? {
        guard let next = base.next() else {
            base = originalIterator
            return base.next()
        }

        return next
    }
}

extension CycleSequence: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator())
    }
}

extension CycleSequence: LazySequenceProtocol {}

extension Sequence {
    /// Returns `self` cycled indefinitely.
    public func cycled() -> CycleSequence<Self> {
        CycleSequence(base: self)
    }
}
