import RegexBuilder

struct ComponentList<Component: RegexComponent>: CustomConsumingRegexComponent {
    typealias RegexOutput = [Component.RegexOutput]

    let component: Component
    let count: Int

    func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let innerInput = input[index..<bounds.upperBound]
        let repeatRegex = {
            if count > 0 {
                Repeat(component, count: count)
            } else {
                Repeat(component, 0...)
            }
        }()
        guard let prefix = innerInput.prefixMatch(of: repeatRegex) else {
            return nil
        }
        let matches = String(prefix.output).matches(of: component)
        guard !matches.isEmpty else {
            return nil
        }
        let output = matches.map(\.output)
        return (prefix.range.upperBound, output)
    }
}
