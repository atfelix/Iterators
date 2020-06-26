/// A lazy sequence which produces overlapping windows with `size`
/// elements of the base sequence.  If the window size is larger than
/// the base sequences size, then no windows are produced.
public struct LazyWindowSequence<Base: Sequence> {
    internal let base: Base
    internal let size: Int

    internal init(base: Base, size: Int) {
        precondition(size > 0)

        self.base = base
        self.size = size
    }
}

extension LazyWindowSequence {
    /// An iterator which produces overlapping windows of `base`
    /// sequence where if the window size is larger than the
    /// sequence size, no window is produced.
    public struct Iterator {
        var base: Base.Iterator
        let size: Int
        var currentWindow: [Base.Element] = []
    }
}

extension LazyWindowSequence.Iterator: IteratorProtocol {
    public mutating func next() -> [Base.Element]? {
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
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), size: size)
    }
}

extension LazyWindowSequence: LazySequenceProtocol {}

extension LazySequenceProtocol {
    /// Returns a sequence that provides overlapping windows of `self`
    /// where if `size` is larger than the sequence's size, then
    /// no window is produced
    ///
    /// - Parameter size: The size of the desired chunks
    public func windows(
        of size: Int
    ) -> LazyWindowSequence<Elements> {
        LazyWindowSequence(base: elements, size: size)
    }
}
