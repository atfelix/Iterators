import Iterators
import XCTest

final class MapWhileSequenceTests: XCTestCase {
    func test() {
        XCTAssertEqual(
            [1, 2, 3],
            Array(["1", "2", "3", "four", "5", "6", "seven", "7"].mapWhile(Int.init))
        )
    }
}
