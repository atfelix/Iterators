import Iterators
import XCTest

final class LazySplitOmittingSequenceTests: XCTestCase {
    func testSplitKeepingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(AnySequence("...ab.cdef...ghi...j...k..lm..n...").lazy.splitOmittingEmptySequences(separator: "."))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(AnySequence("ab.cdef...ghi...j...k..lm..n...").lazy.splitOmittingEmptySequences(separator: "."))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(AnySequence("...ab.cdef...ghi...j...k..lm..n").lazy.splitOmittingEmptySequences(separator: "."))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: true).map(Array.init),
            Array(AnySequence(".ab.cdef.ghi.j.k.lm.n.").lazy.splitOmittingEmptySequences(separator: "."))
        )
    }
}
