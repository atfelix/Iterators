extension Collection {
    /// Returns an array of non-overlapping subsequences of size given by `size`
    /// and will not include the final subsequence if `exact` is `true` and the final subsequence has
    /// fewer than `size` elements.
    ///
    /// - Parameter size:  The size of the chunks
    /// - Parameter exact:
    ///     A boolean indicating whether the last chunk should be included if it's
    ///     size isn't equal to `size`.  This parameter defaults to `false`.
    ///
    /// - Usage:
    ///
    /// ```swift
    /// (1 ... 10).chunks(of: 4) == [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
    /// (1 ... 10).chunks(of: 4, exact: true) == [[1, 2, 3, 4], [5, 6, 7, 8]]
    /// ```
    public func chunks(
        of size: Int,
        exact: Bool = false
    ) -> [SubSequence] {
        precondition(size > 0)

        var chunks: [SubSequence] = []
        var currentIndex = startIndex

        while currentIndex < endIndex {
            var copyOfCurrentIndex = currentIndex
            _ = formIndex(&copyOfCurrentIndex, offsetBy: size, limitedBy: endIndex)
            if !exact || distance(from: copyOfCurrentIndex, to: currentIndex).isMultiple(of: size) {
                chunks.append(self[currentIndex ..< copyOfCurrentIndex])
            }
            currentIndex = copyOfCurrentIndex
        }
        return chunks
    }
}

extension Sequence {
    /// Returns an array of non-overlapping arrays of size given by `size`
    /// and will not include the final array if `exact` is `true` and the final array has
    /// fewer than `size` elements.
    ///
    /// - Parameter size:  The size of the chunks
    /// - Parameter exact:
    ///     A boolean indicating whether the last chunk should be included if it's
    ///     size isn't equal to `size`.  This parameter defaults to `false`.
    ///
    /// - Usage:
    ///
    /// ```swift
    /// AnySequence(1 ... 10).chunks(of: 4) == [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
    /// AnySequence(1 ... 10).chunks(of: 4, exact: true) == [[1, 2, 3, 4], [5, 6, 7, 8]]
    /// ```
    public func chunks(
        of size: Int,
        exact: Bool = false
    ) -> [[Self.Element]] {
        var chunks: [[Self.Element]] = []
        var iterator = makeIterator()

        while let first = iterator.next() {
            var currentChunk = [first]
            
            while currentChunk.count < size, let next = iterator.next() {
                currentChunk.append(next)
            }

            if !exact || currentChunk.count == size {
                chunks.append(currentChunk)
            }
        }
        return chunks
    }
}
