import Iterators
import XCTest

final class LazySplitKeepingStringSequenceTests: XCTestCase {
    func testSplitKeepingEmptySubsequences() {
        let first: LazySplitKeepingStringSequence = "...ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: ".")
        let second: LazySplitKeepingStringSequence = "ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: ".")
        let third: LazySplitKeepingStringSequence = "...ab.cdef...ghi...j...k..lm..n".lazy.splitKeepingEmptySubsequences(separator: ".")
        let fourth: LazySplitKeepingStringSequence = ".ab.cdef.ghi.j.k.lm.n.".lazy.splitKeepingEmptySubsequences(separator: ".")
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
