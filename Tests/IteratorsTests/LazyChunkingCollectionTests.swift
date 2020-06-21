import Iterators
import XCTest

final class LazyChunkingCollectionTests: XCTestCase {
    func testChunkInexactCollection() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷", "klm"],
            Array("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".lazy.chunks(of: 4))
        )
    }

    func testChunkExactCollections() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷"],
            Array("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".lazy.chunks(of: 4, exact: true))
        )
    }

    func testChunkInexactBidirectionalCollection() {
        XCTAssertEqual(
            [100],
            Array((1 ... 100).lazy.chunks(of: 3).last!)
        )
    }

    func testChunkExactBidriectionalCollection() {
        XCTAssertEqual(
            [97, 98, 99],
            Array((1 ... 100).lazy.chunks(of: 3, exact: true).last!)
        )
    }
}
