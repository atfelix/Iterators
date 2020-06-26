import Iterators
import XCTest

final class StepBySequenceTests: XCTestCase {
    func testStepBy() {
        XCTAssertEqual(
            [0, 2, 4],
            Array(AnySequence([0, 1, 2, 3, 4, 5]).stepBy(size: 2))
        )
    }
}
