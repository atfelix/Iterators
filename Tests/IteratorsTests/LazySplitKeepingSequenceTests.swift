import Iterators
import XCTest

final class LazySplitKeepingSequenceTests: XCTestCase {
    func testSplitKeepingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(AnySequence("...ab.cdef...ghi...j...k..lm..n...").lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(AnySequence("ab.cdef...ghi...j...k..lm..n...").lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(AnySequence("...ab.cdef...ghi...j...k..lm..n").lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: false).map(Array.init),
            Array(AnySequence(".ab.cdef.ghi.j.k.lm.n.").lazy.splitKeepingEmptySubsequences(separator: "."))
        )
    }
}
