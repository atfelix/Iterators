struct RepeatedForever<Element> {
    let element: Element
}

extension RepeatedForever {
    struct Iterator {
        let element: Element
    }
}

extension RepeatedForever.Iterator: IteratorProtocol {
    mutating func next() -> Element? {
        element
    }
}

extension RepeatedForever: Sequence {
    func makeIterator() -> Iterator {
        Iterator(element: element)
    }
}

func repeatForever<Element>(element: Element) -> RepeatedForever<Element> {
    .init(element: element)
}
