extension Collection {
    /// Returns an array of contiguous subsequence each of length `size`
    ///
    /// - Parameter size:  The window size
    ///
    /// - Note:
    ///     If the collection has size smaller than `size`, then
    ///     no subsequences are produced.
    public func windows(
        of size: Int
    ) -> [SubSequence] {
        precondition(0 < size)

        var currentStartIndex = startIndex

        guard var currentEndIndex = index(currentStartIndex, offsetBy: size, limitedBy: endIndex)
            else { return [] }

        var windows: [SubSequence] = [self[currentStartIndex ..< currentEndIndex]]

        while currentEndIndex < endIndex {
            formIndex(after: &currentStartIndex)
            formIndex(after: &currentEndIndex)
            windows.append(self[currentStartIndex ..< currentEndIndex])
        }

        return windows
    }
}
