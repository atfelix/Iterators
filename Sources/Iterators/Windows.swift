extension Collection {
    func windows(
        of size: Int
    ) -> [SubSequence]? {
        precondition(0 < size)

        var currentStartIndex = startIndex

        guard var currentEndIndex = index(currentStartIndex, offsetBy: size, limitedBy: endIndex)
            else { return nil }

        var windows: [SubSequence] = [self[currentStartIndex ..< currentEndIndex]]

        while currentEndIndex < endIndex {
            formIndex(after: &currentStartIndex)
            formIndex(after: &currentEndIndex)
            windows.append(self[currentStartIndex ..< currentEndIndex])
        }

        return windows
    }
}
