import RegexBuilder
import XCTest
@testable import SwiftRegex

final class ListTests: XCTestCase {

    let digitComponent = Regex {
        One(.digit)
        Optionally(", ")
    }

    func testDigitListWithSingleComponent() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List(digitComponent)

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output)?
            .map(String.init)

        // then
        XCTAssertEqual(output, ["1, ", "2, ", "3, ", "4"])
    }

    func testDigitListWithSingleComponentTransform() {
        // given
        let data = "1, 2, 3, 4"
        let regex = Regex {
            TryCapture(List(digitComponent)) { output in
                output.compactMap { Int(String($0.first!)) }
            }
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
            digitComponent
        }

        // when
        let output = data
            .wholeMatch(of: regex)
            .map(\.output)?
            .map(String.init)

        // then
        XCTAssertEqual(output, ["1, ", "2, ", "3, ", "4"])
    }

    func testDigitListWithComponentBuilderTransform() {
        // given
        let data = "1, 2, 3, 4"
        let list = List {
            digitComponent
        }
        let regex = Regex {
            TryCapture(list) { output in
                output.compactMap { Int(String($0.first!)) }
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
            List(digitComponent)
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
        let regex = List(digitComponent, count: 2)

        // when
        let output = data
            .firstMatch(of: regex)
            .map(\.output)?
            .map(String.init)

        // then
        XCTAssertEqual(output, ["1, ", "2, "])
    }

    func testDigitListWithComponentBuilderWithCount() {
        // given
        let data = "1, 2, 3, 4"
        let regex = List(count: 2) {
            digitComponent
        }

        // when
        let output = data
            .firstMatch(of: regex)
            .map(\.output)?
            .map(String.init)

        // then
        XCTAssertEqual(output, ["1, ", "2, "])
    }

    func testDigitListWithCountRemainder() {
        // given
        let data = "1, 2, 3, 4"
        let regex = Regex {
            List(digitComponent, count: 2)
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
