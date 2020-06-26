import Iterators
import XCTest

final class LazySplitOmittingStringSequenceTests: XCTestCase {
    func testSplitOmittingEmptySubsequences() {
        let first: LazySplitOmittingStringSequence = "...ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySequences(separator: ".")
        let second: LazySplitOmittingStringSequence = "ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySequences(separator: ".")
        let third: LazySplitOmittingStringSequence = "...ab.cdef...ghi...j...k..lm..n".lazy.splitOmittingEmptySequences(separator: ".")
        let fourth: LazySplitOmittingStringSequence = ".ab.cdef.ghi.j.k.lm.n.".lazy.splitOmittingEmptySequences(separator: ".")
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
}
