/// A lazy sequence which produces non-overlapping chunks with `size`
/// elements of the base sequence.  If the last chunk has fewer than
///  `size` elements, it is not produced by this sequence.
public struct LazyChunkingExactSequence<Base: Sequence> {
    internal let base: Base
    internal let size: Int
}

extension LazyChunkingExactSequence {
    /// An iterator which produces non-overlapping chunks of `base`
    /// sequence where the last chunk is not produce if it has fewer
    /// than `size` elements.
    public struct Iterator {
        internal var base: Base.Iterator
        internal let size: Int
    }
}

extension LazyChunkingExactSequence.Iterator: IteratorProtocol {
    /// Returns an optional array `Base.Element`s where `nil` is returned
    /// if the iterator does not have `size` elements left to iterate.
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
        return count == size ? elements : nil
    }
}

extension LazyChunkingExactSequence: Sequence {
    /// Returns an iterator which produces non-overlapping chunks
    /// of `base` where the last chunk is not produce if it has fewer
    /// than `size` elements
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size
        )
    }
}

extension LazySequenceProtocol {
    /// Returns a sequence that provides non-overlapping chunks of `self`
    /// where the last chunk is provided only if it has `size` elements
    ///
    /// - Parameter size: The size of the desired chunks
    public func chunkExactly(
        by size: Int
    ) -> LazyChunkingExactSequence<Elements> {
        LazyChunkingExactSequence(base: elements, size: size)
    }
}
