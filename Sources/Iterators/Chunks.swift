extension Collection {
    func chunks(
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
