import RegexBuilder

struct ComponentList<
    Component: RegexComponent,
    Separator: RegexComponent
>: CustomConsumingRegexComponent {
    typealias RegexOutput = [Component.RegexOutput]

    let component: Component
    let count: Int?
    let separator: Separator
    
    @RegexComponentBuilder
    private var componentWithSeparator: some RegexComponent {
        component
        Optionally(separator)
    }

    func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let innerInput = input[index..<bounds.upperBound]
        let repeatRegex = {
            guard let count, count > 0 else {
                return Repeat(componentWithSeparator, 0...)
            }
            return Repeat(componentWithSeparator, count: count)
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
