import Iterators
import XCTest

final class PeekingIteratorTests: XCTestCase {
    func testPeekingIterator() {
        var iterator = [1,2,3].makeIterator().peekable()
        XCTAssertEqual(1, iterator.peek())
        XCTAssertEqual(1, iterator.next())
        XCTAssertEqual(2, iterator.next())
        XCTAssertEqual(3, iterator.peek())
        XCTAssertEqual(3, iterator.peek())
        XCTAssertEqual(3, iterator.next())
        XCTAssertEqual(nil, iterator.peek())
        XCTAssertEqual(nil, iterator.next())
    }
}
