import RegexBuilder

public struct List<Component: RegexComponent>: CustomConsumingRegexComponent {
    public typealias RegexOutput = [Component.RegexOutput]

    private let component: Component

    private init() {
        fatalError()
    }

    public func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let innerInput = input[index..<bounds.upperBound]
        let repeatRegex = Regex {
            Repeat(0...) {
                component
            }
        }
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

public extension List {
    init(_ component: Component) {
        self.component = component
    }

    init(@RegexComponentBuilder _ builder: () -> Component) {
        self.component = builder()
    }
}
