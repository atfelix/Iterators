struct PeekingIterator<Base: IteratorProtocol> {
    var base: Base
    var current: Base.Element?

    init(base: Base) {
        self.base = base
    }

    mutating func peek() -> Base.Element? {
        if current == nil {
           current = base.next()
        }
        return current
    }
}

extension PeekingIterator: IteratorProtocol {
    mutating func next() -> Base.Element? {
        let temp = current
        current = base.next()

        return temp
    }
}

extension IteratorProtocol {
    func peekable() -> PeekingIterator<Self> {
        PeekingIterator(base: self)
    }
}
