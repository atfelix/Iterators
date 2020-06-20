import Iterators
import XCTest

final class CycleSequenceTests: XCTestCase {
    func testCycled() {
        let cycled = (1 ... 4).cycled().prefix(8).map { $0 }
        XCTAssertEqual(
            [1, 2, 3, 4, 1, 2, 3, 4],
            cycled
        )
    }

    func testCycledLazy() {
        let cycled = (1 ... 4).lazy.cycled().prefix(8)
        XCTAssertEqual(
            [1, 2, 3, 4, 1, 2, 3, 4],
            Array(cycled)
        )
    }
}
