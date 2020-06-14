struct LazyChunkingSequence<Base: Sequence> {
    let base: Base
    let size: Int
    let exact: Bool
}

extension LazyChunkingSequence {
    struct Iterator {
        var base: Base.Iterator
        let size: Int
        let exact: Bool
    }
}

extension LazyChunkingSequence.Iterator: IteratorProtocol {
    mutating func next() -> [Base.Element]? {
        guard let element = base.next() else { return nil }

        var elements = [element]
        var count = 1
        while count < size, let element = base.next() {
            elements.append(element)
            count += 1
        }
        return !exact || count == size ? elements : nil
    }
}

extension LazyChunkingSequence: Sequence {
    func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size,
            exact: exact
        )
    }
}

extension LazySequenceProtocol {
    func chunks(
        of size: Int,
        exact: Bool = false
    ) -> LazyChunkingSequence<Elements> {
        LazyChunkingSequence(
            base: elements,
            size: size,
            exact: exact
        )
    }
}
