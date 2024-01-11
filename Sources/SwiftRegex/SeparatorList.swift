import Foundation
import RegexBuilder

struct SeparatorList: CustomConsumingRegexComponent {
    typealias RegexOutput = [String]

    let separator: String
    let lookahead: String?

    func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let lookaheadRange = lookahead.flatMap(input[index..<bounds.upperBound].firstRange)
        let innerInputUpperBound = lookaheadRange?.lowerBound ?? bounds.upperBound
        let innerInput = input[index..<innerInputUpperBound]
        let output = innerInput.components(separatedBy: separator)
        guard !output.isEmpty else {
            return nil
        }
        return (innerInputUpperBound, output)
    }
}
