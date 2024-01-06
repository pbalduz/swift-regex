import RegexBuilder

public struct List<Component: RegexComponent>: CustomConsumingRegexComponent {
    public typealias RegexOutput = [Component.RegexOutput]

    private let component: Component
    private let count: Int

    private init() {
        fatalError()
    }

    public func consuming(
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

public extension List {
    init(
        _ component: Component,
        count: Int = 0
    ) {
        self.component = component
        self.count = count
    }

    init(
        count: Int = 0,
        @RegexComponentBuilder _ builder: () -> Component
    ) {
        self.component = builder()
        self.count = count
    }
}
