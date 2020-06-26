/// An iterator that allows peeking on the next element
public struct PeekingIterator<Base: IteratorProtocol> {
    internal var base: Base
    internal var current: Base.Element?

    internal init(base: Base) {
        self.base = base
    }

    public mutating func peek() -> Base.Element? {
        if current == nil {
           current = base.next()
        }
        return current
    }
}

extension PeekingIterator: IteratorProtocol {
    public mutating func next() -> Base.Element? {
        let temp = current
        current = base.next()

        return temp
    }
}

extension IteratorProtocol {
    /// Returns a `PeekingIterator`
    public func peekable() -> PeekingIterator<Self> {
        PeekingIterator(base: self)
    }
}
