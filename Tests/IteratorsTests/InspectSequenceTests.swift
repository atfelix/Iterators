import Iterators
import XCTest

final class InspectSequenceTests: XCTestCase {
    func testInspect() {
        var outputs: [Int] = []
        var filteredOutputs: [Int] = []

        let array = (1 ... 20)
            .inspect { outputs.append($0) }
            .filter { $0.isMultiple(of: 4) }
            .inspect { filteredOutputs.append($0) }

        _ = Array(array)

        XCTAssertEqual(Array(1 ... 20), outputs)
        XCTAssertEqual(Array(stride(from: 4, through: 20, by: 4)), filteredOutputs)
    }
}
