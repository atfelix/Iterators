import Iterators
import XCTest

final class LazyChunkingInexactSequence: XCTestCase {
    func testExact() {
        var iterator = AnySequence(1 ... 20).lazy.chunkInexactly(by: 4).makeIterator()
        XCTAssertEqual([1, 2, 3, 4], iterator.next())
        XCTAssertEqual([5, 6, 7, 8], iterator.next())
        XCTAssertEqual([9, 10, 11, 12], iterator.next())
        XCTAssertEqual([13, 14, 15, 16], iterator.next())
        XCTAssertEqual([17, 18, 19, 20], iterator.next())
        XCTAssertEqual(nil, iterator.next())
    }

    func testInexact() {
        var iterator = AnySequence(1 ... 22).lazy.chunkInexactly(by: 4).makeIterator()
        XCTAssertEqual([1, 2, 3, 4], iterator.next())
        XCTAssertEqual([5, 6, 7, 8], iterator.next())
        XCTAssertEqual([9, 10, 11, 12], iterator.next())
        XCTAssertEqual([13, 14, 15, 16], iterator.next())
        XCTAssertEqual([17, 18, 19, 20], iterator.next())
        XCTAssertEqual([21, 22], iterator.next())
        XCTAssertEqual(nil, iterator.next())
    }
}
