import Iterators
import XCTest

final class LazySplitStringCollectionTests: XCTestCase {
    func testSplitOmittingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array("ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: true))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: true),
            Array("...ab.cdef...ghi...j...k..lm..n".lazy.split(separator: ".", omittingEmptySubsequences: true))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: true),
            Array(".ab.cdef.ghi.j.k.lm.n.".lazy.split(separator: ".", omittingEmptySubsequences: true))
        )
    }

    func testSplitKeepingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array("ab.cdef...ghi...j...k..lm..n...".lazy.split(separator: ".", omittingEmptySubsequences: false))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: false),
            Array("...ab.cdef...ghi...j...k..lm..n".lazy.split(separator: ".", omittingEmptySubsequences: false))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: false),
            Array(".ab.cdef.ghi.j.k.lm.n.".lazy.split(separator: ".", omittingEmptySubsequences: false))
        )
    }
}
