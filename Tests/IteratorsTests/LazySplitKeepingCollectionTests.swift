import Iterators
import XCTest

final class LazySplitKeepingCollectionTests: XCTestCase {
    func testSplitKeepingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: false),
            Array("ab.cdef...ghi...j...k..lm..n...".lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: false),
            Array("...ab.cdef...ghi...j...k..lm..n".lazy.splitKeepingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: false),
            Array(".ab.cdef.ghi.j.k.lm.n.".lazy.splitKeepingEmptySubsequences(separator: "."))
        )
    }
}
