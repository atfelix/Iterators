import Iterators
import XCTest

final class LazySplitStringSequenceTests: XCTestCase {
    func testSplitOmittingEmptySubsequences() {
        let first: LazySplitStringSequence = "...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true)
        let second: LazySplitStringSequence = "ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true)
        let third: LazySplitStringSequence = "...ab.cdef...ghi...j...k..lm..n".lazy.split(separator: ".", omittingEmptySubsequences: true)
        let fourth: LazySplitStringSequence = ".ab.cdef.ghi.j.k.lm.n.".lazy.split(separator: ".", omittingEmptySubsequences: true)
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array(first)
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array(second)
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: true),
            Array(third)
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: true),
            Array(fourth)
        )
    }

    func testSplitKeepingEmptySubsequences() {
        let first: LazySplitStringSequence = "...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false)
        let second: LazySplitStringSequence = "ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false)
        let third: LazySplitStringSequence = "...ab.cdef...ghi...j...k..lm..n".lazy.split(separator: ".", omittingEmptySubsequences: false)
        let fourth: LazySplitStringSequence = ".ab.cdef.ghi.j.k.lm.n.".lazy.split(separator: ".", omittingEmptySubsequences: false)
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array(first)
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array(second)
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: false),
            Array(third)
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: false),
            Array(fourth)
        )
    }
}
