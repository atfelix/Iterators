import Iterators
import XCTest

final class ChainSequenceTests: XCTestCase {
    func testChain() {
        let sequence1 = (1 ... 4)
        let sequence2 = [5, 6, 7, 8]
        let sequence3 = sequence(first: 9) { return $0 == 12 ? nil : $0 + 1 }

        let chained = sequence1.chain(sequence2).chain(sequence3)

        XCTAssertEqual(Array(1 ... 12), Array(chained))
    }

    func testChainLazy() {
        let sequence1 = (1 ... 4).lazy
        let sequence2 = [5, 6, 7, 8].lazy
        let sequence3 = sequence(first: 9) { return $0 == 12 ? nil : $0 + 1 }.lazy

        let chained = sequence1.chain(sequence2).chain(sequence3)

        XCTAssertEqual(Array(1 ... 12), Array(chained))
    }
}
