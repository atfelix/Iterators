/// A sequence of non-overlapping arrays of elements of size given by `size`
/// and will not include the final array if `exact` is `true` and the final
/// subsequence fewer than `size` elements
public struct LazyChunkingSequence<Base: Sequence> {
    internal let base: Base
    internal let size: Int
    internal let exact: Bool
}

extension LazyChunkingSequence {
    /// An iterator that provides non-overlapping arrays of elements of given by `size`
    /// and will not include the final array if `exact` is `true` and the final
    /// array of elements has fewer than `size elements`
    public struct Iterator {
        internal var base: Base.Iterator
        internal let size: Int
        internal let exact: Bool
    }
}

extension LazyChunkingSequence.Iterator: IteratorProtocol {
    /// Returns the next non-overlapping chunk remaining in the base sequence
    /// if there are any more elements and the chunk has exactly `size` elements
    /// or the chunk is the last chunk of the sequence and `exact` is false
    ///
    /// - Complexity: _O(`size`)_
    public mutating func next() -> [Base.Element]? {
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
    public func makeIterator() -> Iterator {
        Iterator(
            base: base.makeIterator(),
            size: size,
            exact: exact
        )
    }
}

extension LazySequenceProtocol {
    /// Returns a `LazyChunkingSequence`
    ///
    /// - Parameter size:  The size of the chunks
    /// - Parameter exact:
    ///     The boolean indicating whether or not to include the last subsequence
    ///     when it doesn't contain `size` elements
    public func chunks(
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
