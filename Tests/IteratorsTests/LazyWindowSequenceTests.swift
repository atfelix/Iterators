import Iterators
import XCTest

final class LazyWindowSequenceTests: XCTestCase {
    func testWindowSequence() {
        XCTAssertEqual(
            ["🏳️ab🇦🇫", "ab🇦🇫c", "b🇦🇫cd", "🇦🇫cd🇦🇩"].map(Array.init),
            Array(AnySequence("🏳️ab🇦🇫cd🇦🇩").lazy.windows(of: 4))
        )
    }

    func testWindowTooLarge() {
        XCTAssertEqual(
            [],
            Array(AnySequence(1 ... 10).lazy.windows(of: 11).map(Array.init))
        )
    }
}
