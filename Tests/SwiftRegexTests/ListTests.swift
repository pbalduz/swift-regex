import RegexBuilder
import XCTest
@testable import SwiftRegex

final class ListTests: XCTestCase {

    func testDigitListWithSingleComponent() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List(One(.digit), separator: ", ")

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output)

        // then
        XCTAssertEqual(output, ["1", "2", "3", "4"])
    }

    func testDigitListWithSingleComponentTransform() {
        // given
        let data = "1, 2, 3, 4"
        let regex = TryCapture(
            List(One(.digit), separator: ", ")
        ) { output in
            output.compactMap { Int($0) }
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output.1)

        // then
        XCTAssertEqual(output, [1, 2, 3, 4])
    }

    func testDigitListWithComponentBuilder() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List {
            One(.digit)
        } separator: {
            ", "
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output)
        
        // then
        XCTAssertEqual(output, ["1", "2", "3", "4"])
    }

    func testDigitListWithComponentBuilderTransform() {
        // given
        let data = "1, 2, 3, 4"
        let list = List {
            One(.digit)
        } separator: {
            ", "
        }
        let regex = Regex {
            TryCapture(list) { output in
                output.compactMap { Int($0) }
            }
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output.1)

        // then
        XCTAssertEqual(output, [1, 2, 3, 4])
    }

    func testDigitListRemainder() {
        // given
        let data = "1, 2, 3, 4 - 5, 6, 7, 8"
        let regex = Regex {
            List(One(.digit), separator: ", ")
            Capture(OneOrMore(.any))
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output.1)

        // then
        XCTAssertEqual(output, " - 5, 6, 7, 8")
    }

    func testDigitListWithSingleComponentWithCount() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List(
            One(.digit),
            count: 2,
            separator: ", "
        )

        // when
        let output = data
            .firstMatch(of: regex)
            .map(\.output)

        // then
        XCTAssertEqual(output, ["1", "2"])
    }

    func testDigitListWithComponentBuilderWithCount() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List(count: 2) {
            One(.digit)
        } separator: {
            ", "
        }

        // when
        let output = data
            .firstMatch(of: regex)
            .map(\.output)
        
        // then
        XCTAssertEqual(output, ["1", "2"])
    }

    func testDigitListWithCountRemainder() {
        // given
        let data = "1, 2, 3, 4"
        let regex = Regex {
            List(One(.digit), count: 2, separator: ", ")
            Capture(OneOrMore(.any))
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output.1)

        // then
        XCTAssertEqual(output, "3, 4")
    }
}
