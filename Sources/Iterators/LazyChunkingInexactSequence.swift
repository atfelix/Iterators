/// A lazy sequence which produces non-overlapping chunks with `size`
/// elements of the base sequence.
public struct LazyChunkingInexactSequence<Base: Sequence> {
    internal let base: Base
    internal let size: Int
}

extension LazyChunkingInexactSequence {
    /// An iterator which produces non-overlapping chunks of `base`
    /// sequence.
    public struct Iterator {
        internal var base: Base.Iterator
        internal let size: Int
    }
}

extension LazyChunkingInexactSequence.Iterator: IteratorProtocol {
    /// Returns an optional array `Base.Element`s where `nil` is returned
    /// if the iterator does not any more elements.
    ///
    /// - Complexity: _O(size)_
    public mutating func next() -> [Base.Element]? {
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
    /// Returns an iterator which produces non-overlapping chunks
    /// of `base`.
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size
        )
    }
}

extension LazySequenceProtocol {
    /// Returns a sequence that provides non-overlapping chunks of `self`.
    ///
    /// - Parameter size: The size of the desired chunks
    public func chunkInexactly(
        by size: Int
    ) -> LazyChunkingInexactSequence<Elements> {
        LazyChunkingInexactSequence(base: elements, size: size)
    }
}
