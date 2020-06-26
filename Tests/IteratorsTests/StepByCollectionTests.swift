import Iterators
import XCTest

final class StepByCollectionTests: XCTestCase {
    func testStepBy() {
        XCTAssertEqual(
            [0, 2, 4],
            Array([0, 1, 2, 3, 4, 5].lazy.stepBy(size: 2))
        )
        XCTAssertEqual(
            [0, 2, 4, 6],
            Array([0, 1, 2, 3, 4, 5, 6].lazy.stepBy(size: 2))
        )
        XCTAssertEqual(
            [0, 2, 4],
            Array([0, 1, 2, 3, 4, 5].stepBy(size: 2))
        )
        XCTAssertEqual(
            [0, 2, 4, 6],
            Array([0, 1, 2, 3, 4, 5, 6].stepBy(size: 2))
        )
    }
}
