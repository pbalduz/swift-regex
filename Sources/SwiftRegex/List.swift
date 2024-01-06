import RegexBuilder

public struct List<Output>: RegexComponent {
    public typealias RegexOutput = Output

    public var regex: Regex<Output>
}

public extension List {
    init<C: RegexComponent>(
        _ component: C,
        count: Int = 0
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: component,
            count: count
        )
        .regex
    }

    init<C: RegexComponent>(
        count: Int = 0,
        @RegexComponentBuilder _ builder: () -> C
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: builder(),
            count: count
        )
        .regex
    }
}

public extension List where Output == [String] {
    init(
        separator: String,
        lookahead: String? = nil
    ) {
        self.regex = SeparatorList(
            separator: separator,
            lookahead: lookahead
        )
        .regex
    }
}
