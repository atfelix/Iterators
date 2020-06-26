import Iterators
import XCTest

final class WindowsTests: XCTestCase {
    func testWindows() {
        XCTAssertEqual(
            [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
            (1 ... 5).windows(of: 3).map(Array.init)
        )
    }
}
