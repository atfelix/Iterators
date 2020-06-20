import XCTest
@testable import Iterators

final class IteratorsTests: XCTestCase {
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

    func test8() {
        XCTAssertEqual(Array(repeatForever(element: 1).prefix(5)), [1,1,1,1,1])
    }

    func test9() {
        XCTAssertEqual(
            ["", "", "", "ab", "cdef", "", "", "ghi", "", "", "j", "", "", "k", "", "lm", "", "n", "", "", ""],
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false))
        )
    }

    func test10() {
        XCTAssertEqual(
            ["ab", "cdef", "ghi", "j", "k", "lm", "n"],
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true))
        )
    }

    func test11() {
        XCTAssertEqual(
            ["", "", "", "ab", "cdef", "", "", "ghi", "", "", "j", "", "", "k", "", "lm", "", "n", "", "", ""],
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: "."))
        )
    }

    func test12() {
        XCTAssertEqual(
            ["ab", "cdef", "ghi", "j", "k", "lm", "n"],
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySubsequences(separator: "."))
        )
    }

    func test13() {
        XCTAssertEqual(
            [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
            (1 ... 5).windows(of: 3)?.map(Array.init)
        )
    }

    func test14() {
        XCTAssertEqual(
            [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
            (1 ... 5).lazy.windows(of: 3)?.map(Array.init)
        )
    }
}
