import Iterators
import XCTest

final class LazySplitOmittingCollectionTests: XCTestCase {
    func testSplitOmittingEmptySubsequences() {
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array("...ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "ab.cdef...ghi...j...k..lm..n...".split(separator: ".", omittingEmptySubsequences: true),
            Array("ab.cdef...ghi...j...k..lm..n...".lazy.splitOmittingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            "...ab.cdef...ghi...j...k..lm..n".split(separator: ".", omittingEmptySubsequences: true),
            Array("...ab.cdef...ghi...j...k..lm..n".lazy.splitOmittingEmptySubsequences(separator: "."))
        )
        XCTAssertEqual(
            ".ab.cdef.ghi.j.k.lm.n.".split(separator: ".", omittingEmptySubsequences: true),
            Array(".ab.cdef.ghi.j.k.lm.n.".lazy.splitOmittingEmptySubsequences(separator: "."))
        )
    }
}
