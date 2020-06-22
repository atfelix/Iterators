import Iterators
import XCTest

final class LazyChunkingExactCollectionTests: XCTestCase {
    func testExact() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷"],
            Array("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".lazy.chunkExactly(by: 4))
        )
    }

    func testExactBidirectional() {
        XCTAssertEqual(
            [97, 98, 99],
            Array((1 ... 100).lazy.chunkExactly(by: 3).last!)
        )
    }
}
