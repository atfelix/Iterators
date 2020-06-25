import Iterators
import XCTest

final class LazyChunkingInexactCollectionTests: XCTestCase {
    func testInexact() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷", "klm"],
            Array("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".lazy.chunkInexactly(by: 4))
        )
    }

    func testInexactBidirectional() {
        XCTAssertEqual(
            [100],
            Array((1 ... 100).lazy.chunkInexactly(by: 3).last!)
        )
    }
}
