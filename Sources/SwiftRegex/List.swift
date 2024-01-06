import RegexBuilder

/// A regex component that matches a number of occurrences of its underlying
/// component whose output corresponds to an array containing the occurrences
/// outputs.
///
/// The underlying component can be identified using a custom `RegexComponent`
/// or the occurrences separator as a `String`.
public struct List<Output>: RegexComponent {
    public typealias RegexOutput = Output

    public var regex: Regex<Output>
}

public extension List {
    
    /// Creates a regex component that matches the given component repeated
    /// the specified number of times whose output corresponds to an array
    /// containing the occurrences outputs.
    ///
    /// For example, a comma separated list of numbers can be matched by using
    /// the `List` component:
    ///
    /// ```swift
    /// let data = "1, 2, 3, 4"
    /// let component = Regex {
    ///     One(.digit)
    ///     Optionally(", ")
    /// }
    /// let list = List(component)
    /// let output = data
    ///     .wholeMatch(of: regex)
    ///     .map(\.output) // ["1, ", "2, ", "3, ", "4"]
    /// ```
    ///
    /// - Parameters:
    ///   - component: The regex component to repeat.
    ///   - count: The number of times to repeat `component`. If `count`
    ///     isn't greater than zero `component` will be repeated as many
    ///     times as possible.
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

    /// Creates a regex component that matches the given component repeated
    /// the specified number of times whose output corresponds to an array
    /// containing the occurrences outputs.
    ///
    /// For example, a comma separated list of numbers can be matched by using
    /// the `List` component:
    ///
    /// ```swift
    /// let data = "1, 2, 3, 4"
    /// let list = List {
    ///     One(.digit)
    ///     Optionally(", ")
    /// }
    /// let output = data
    ///     .wholeMatch(of: regex)
    ///     .map(\.output) // ["1, ", "2, ", "3, ", "4"]
    /// ```
    ///
    /// - Parameters:
    ///   - builder: A builder closure that creates the regex
    ///     component to repeat.
    ///   - count: The number of times to repeat `component`. If `count`
    ///     isn't greater than zero `component` will be repeated as many
    ///     times as possible.
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

    /// Creates a regex component that matches a list of components joined
    /// by a given separator.
    ///
    /// For example, a comma separated list of numbers can be matched by using
    /// the `List` component:
    ///
    /// ```swift
    /// let data = "1, 2, 3, 4 - 5, 6, 7, 8"
    /// let list = List(
    ///     separator: ", ",
    ///     lookahead: " - "
    /// )
    /// let output = data
    ///     .firstMatch(of: regex)
    ///     .map(\.output) // ["1", "2", "3", "4"]
    /// ```
    ///
    /// This initializer filters out the separator in the `List` component's output.
    ///
    /// - Parameters:
    ///   - separator: The string that joins all the list components.
    ///   - lookahead: The component until which the `List` component
    ///   should match.
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
