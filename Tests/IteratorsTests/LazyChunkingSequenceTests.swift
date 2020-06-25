import Iterators
import XCTest

final class LazyChunkingSequenceTests: XCTestCase {
    func testChunkInexactSequence() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷", "klm"].map(Array.init),
            Array(AnySequence("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm").lazy.chunks(of: 4))
        )
    }

    func testChunkExactSequence() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "cd🇦🇩e", "f🇦🇬gh", "🇦🇹ij🇧🇷"].map(Array.init),
            Array(AnySequence("🏳️ab🇦🇫cd🇦🇩ef🇦🇬gh🇦🇹ij🇧🇷klm").lazy.chunks(of: 4, exact: true))
        )
    }

    func testChunkInexactBidirectionalSequence() {
        XCTAssertEqual(
            [100],
            Array(AnySequence(1 ... 100).lazy.chunks(of: 3).last!)
        )
    }

    func testChunkExactBidriectionalSequence() {
        XCTAssertEqual(
            [97, 98, 99],
            Array(AnySequence(1 ... 100).lazy.chunks(of: 3, exact: true).last!)
        )
    }
}
