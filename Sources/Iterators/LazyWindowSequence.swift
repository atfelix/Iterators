struct LazyWindowSequence<Base: Sequence> {
    let base: Base
    let size: Int

    init(base: Base, size: Int) {
        precondition(size > 0)

        self.base = base
        self.size = size
    }
}

extension LazyWindowSequence {
    struct Iterator {
        var base: Base.Iterator
        let size: Int
        var currentWindow: [Base.Element] = []
    }
}

extension LazyWindowSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        if !currentWindow.isEmpty {
            currentWindow.removeFirst()
        }
        while let element = base.next() {
            currentWindow.append(element)

            if currentWindow.count == size {
                return currentWindow
            }
        }

        return nil
    }
}

extension LazyWindowSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), size: size)
    }
}

extension LazySequenceProtocol {
    func windows(
        of size: Int
    ) -> LazyWindowSequence<Elements> {
        LazyWindowSequence(base: elements, size: size)
    }
}
