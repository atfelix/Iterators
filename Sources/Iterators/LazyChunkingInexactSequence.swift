struct LazyChunkingInexactSequence<Base: Sequence> {
    let base: Base
    let size: Int
}

extension LazyChunkingInexactSequence {
    struct Iterator {
        var base: Base.Iterator
        let size: Int
    }
}

extension LazyChunkingInexactSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        guard let element = base.next() else { return nil }

        var elements = [element]
        var count = 1
        while count < size, let element = base.next() {
            elements.append(element)
            count += 1
        }
        return elements
    }
}

extension LazyChunkingInexactSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size
        )
    }
}

extension LazySequenceProtocol {
    func chunkInexactly(
        by size: Int
    ) -> LazyChunkingInexactSequence<Elements> {
        LazyChunkingInexactSequence(base: elements, size: size)
    }
}
