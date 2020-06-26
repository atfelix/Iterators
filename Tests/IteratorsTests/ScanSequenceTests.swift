import Iterators
import XCTest

final class ScanSequenceTests: XCTestCase {
    func testScan() {
        let array = [1,2,3].scan(into: 1) { state, int -> Int? in
            state *= int
            return .some(-state)
        }
        let a = Array(array)
        var iterator = array.makeIterator()
        XCTAssertEqual(iterator.next(), -1)
        XCTAssertEqual(iterator.next(), -2)
        XCTAssertEqual(iterator.next(), -6)
        XCTAssertEqual(iterator.next(), nil)
        XCTAssertEqual([-1, -2, -6], a)
    }
}
