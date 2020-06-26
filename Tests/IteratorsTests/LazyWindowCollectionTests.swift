import Iterators
import XCTest

final class LazyWindowCollectionTests: XCTestCase {
    func testWindowCollection() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "ab🇦🇫c", "b🇦🇫cd", "🇦🇫cd🇦🇩"],
            Array("🏳️ab🇦🇫cd🇦🇩".lazy.windows(of: 4))
        )
    }

    func testChunkInexactBidirectionalCollection() {
        XCTAssertEqual(
            [98, 99, 100],
            Array((1 ... 100).lazy.windows(of: 3).last!)
        )
    }

    func testWindowTooLarge() {
        XCTAssertEqual(
            [],
            Array((1 ... 10).lazy.windows(of: 11).map(Array.init))
        )
    }
}
