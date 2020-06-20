import Iterators
import XCTest

final class ChunkAlgorithmTests: XCTestCase {
    func testChunkInexactAlgorithmForCollections() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷", "klm"],
            "🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".chunks(of: 4)
        )
    }

    func testChunkExactAlgorithmForCollections() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷"],
            "🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm".chunks(of: 4, exact: true)
        )
    }

    func testChunkInexactAlgorithmForSequences() {
        XCTAssertEqual(
            AnySequence(1 ... 10).chunks(of: 4),
            [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
        )
    }

    func testChunkExactAlgorithmForSequences() {
        XCTAssertEqual(
            AnySequence(1 ... 10).chunks(of: 4, exact: true),
            [[1, 2, 3, 4], [5, 6, 7, 8]]
        )
    }
}
