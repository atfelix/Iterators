/// A sequence that repeats `element` indefinitely
public struct RepeatedForever<Element> {
    internal let element: Element
}

extension RepeatedForever {
    // An iterator that repeats `element` indefinitely
    public struct Iterator {
        internal let element: Element
    }
}

extension RepeatedForever.Iterator: IteratorProtocol {
    public mutating func next() -> Element? {
        element
    }
}

extension RepeatedForever: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(element: element)
    }
}

extension RepeatedForever: LazySequenceProtocol {}

/// Returns a sequence that repeats `element` indefinitely
public func repeatForever<Element>(element: Element) -> RepeatedForever<Element> {
    .init(element: element)
}
