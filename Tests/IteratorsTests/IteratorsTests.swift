import XCTest
@testable import Iterators

final class IteratorsTests: XCTestCase {
    func test() {
        let chain = AnySequence([1,2,3,4,5]).lazy.chain(other: AnySequence(6...10).lazy)
        XCTAssertEqual([1,2,3,4,5,6,7,8,9,10], Array(chain))
    }

    func test1() {
        let chain = sequence(first: 1) { $0 == 10 ? nil : $0 + 1 }
            .lazy
            .chain(other: sequence(first: 10) { $0 >= 100 ? nil : $0 * 2 })
        XCTAssertEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 20, 40, 80, 160], Array(chain))
    }

    func test2() {
        let cycle = sequence(first: 1) { $0 == 10 ? nil : $0 + 1 }
            .cycled()
            .prefix(20)
        XCTAssertEqual([1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10], Array(cycle))
    }

    func test3() {
        var outputs: [Int] = []
        let seq = sequence(first: 1) { $0 == 10 ? nil : $0 + 1 }
            .inspect { outputs.append($0) }
        _ = Array(seq)
        XCTAssertEqual([1,2,3,4,5,6,7,8,9,10], outputs)
    }

    func test4() {
        let array = ["1", "2", "3", "four", "5", "6", "seven", "7"]
        XCTAssertEqual(Array(array.mapWhile(Int.init)), [1,2,3])
    }

    func test5() {
        var iterator = [1,2,3].makeIterator().peekable()
        XCTAssertEqual(1, iterator.peek())
        XCTAssertEqual(1, iterator.next())
        XCTAssertEqual(2, iterator.next())
        XCTAssertEqual(3, iterator.peek())
        XCTAssertEqual(3, iterator.peek())
        XCTAssertEqual(3, iterator.next())
        XCTAssertEqual(nil, iterator.peek())
        XCTAssertEqual(nil, iterator.next())
    }

    func test6() {
        let array = [1,2,3].scan(into: 1) { state, int -> Int? in
            state *= int
            return .some(-state)
        }
        let a = Array(array)
        var iterator = array.makeIterator()
        XCTAssertEqual(iterator.next(), -1)
        XCTAssertEqual(iterator.next(), -2)
        XCTAssertEqual(iterator.next(), -6)
        XCTAssertEqual(iterator.next(), nil)
        XCTAssertEqual([-1, -2, -6], a)
    }

    func test7() {
        XCTAssertEqual(Array([0, 1, 2, 3, 4, 5].stepBy(size: 2)), [0, 2, 4])
    }
}
