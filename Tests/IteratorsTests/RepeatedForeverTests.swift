import Iterators
import XCTest

final class RepeatedForeverTests: XCTestCase {
    func testRepeatedForever() {
        XCTAssertEqual(
            [1, 1, 1, 1, 1],
            Array(repeatForever(element: 1).prefix(5))
        )
    }
}
