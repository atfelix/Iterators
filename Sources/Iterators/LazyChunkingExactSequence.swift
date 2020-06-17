struct LazyChunkingExactSequence<Base: Sequence> {
    let base: Base
    let size: Int
}

extension LazyChunkingExactSequence {
    struct Iterator {
        var base: Base.Iterator
        let size: Int
    }
}

extension LazyChunkingExactSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        guard let element = base.next() else { return nil }

        var elements = [element]
        var count = 1
        while count < size, let element = base.next() {
            elements.append(element)
            count += 1
        }
        return count == size ? elements : nil
    }
}

extension LazyChunkingExactSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size
        )
    }
}

extension LazySequenceProtocol {
    func chunkExactly(
        by size: Int
    ) -> LazyChunkingExactSequence<Elements> {
        LazyChunkingExactSequence(base: elements, size: size)
    }
}
