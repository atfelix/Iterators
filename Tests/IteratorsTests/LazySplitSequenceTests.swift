import Iterators
import XCTest

final class LazySplitSequenceTests: XCTestCase {
    func testSplitOmittingEmptySubsequences() {
        let first: LazySplitSequence = AnySequence("...ab.cdef...ghi...j...k..lm..n...").lazy.split(separator: ".", omittingEmptySubsequences: true)
        let second: LazySplitSequence = AnySequence("ab.cdef...ghi...j...k..lm..n...").lazy.split(separator: ".", omittingEmptySubsequences: true)
        let third: LazySplitSequence = AnySequence("...ab.cdef...ghi...j...k..lm..n").lazy.split(separator: ".", omittingEmptySubsequences: true)
        let fourth: LazySplitSequence = AnySequence(".ab.cdef.ghi.j.k.lm.n.").lazy.split(separator: ".", omittingEmptySubsequences: true)
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(first)
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(second)
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(third)
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(fourth)
        )
    }

    func testSplitKeepingEmptySubsequences() {
        let first: LazySplitSequence = AnySequence("...ab.cdef...ghi...j...k..lm..n...").lazy.split(separator: ".", omittingEmptySubsequences: false)
        let second: LazySplitSequence = AnySequence("ab.cdef...ghi...j...k..lm..n...").lazy.split(separator: ".", omittingEmptySubsequences: false)
        let third: LazySplitSequence = AnySequence("...ab.cdef...ghi...j...k..lm..n").lazy.split(separator: ".", omittingEmptySubsequences: false)
        let fourth: LazySplitSequence = AnySequence(".ab.cdef.ghi.j.k.lm.n.").lazy.split(separator: ".", omittingEmptySubsequences: false)
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(first)
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(second)
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(third)
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(fourth)
        )
    }
}
