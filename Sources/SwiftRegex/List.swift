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
    /// let list = List(One(.digit), separator: ", ")
    /// let output = data
    ///     .wholeMatch(of: regex)
    ///     .map(\.output) // ["1", "2", "3", "4"]
    /// ```
    ///
    /// - Parameters:
    ///   - component: The regex component to repeat.
    ///   - separator: The regex separator component.
    init<C: RegexComponent, S: RegexComponent>(
        _ component: C,
        separator: S
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: component,
            count: nil,
            separator: separator
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
    /// let list = List(One(.digit), count: 2, separator: ", ")
    /// let output = data
    ///     .firstMatch(of: regex)
    ///     .map(\.output) // ["1", "2"]
    /// ```
    ///
    /// - Parameters:
    ///   - component: The regex component to repeat.
    ///   - count: The number of times to repeat `component`. If `count`
    ///     isn't greater than zero `component` will be repeated as many
    ///     times as possible.
    ///   - separator: The regex component that joins all the `component`
    ///     occurrences.
    init<C: RegexComponent, S: RegexComponent>(
        _ component: C,
        count: Int,
        separator: S
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: component,
            count: count,
            separator: separator
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
    /// } separator: { ", " }
    /// let output = data
    ///     .wholeMatch(of: regex)
    ///     .map(\.output) // ["1, ", "2, ", "3, ", "4"]
    /// ```
    ///
    /// - Parameters:
    ///   - component: A builder closure that creates the regex
    ///     component to repeat.
    ///   - separator: A builder closure that creates the regex
    ///     component that joins all the `component` occurrences.
    init<C: RegexComponent, S: RegexComponent>(
        @RegexComponentBuilder component componentBuilder: () -> C,
        @RegexComponentBuilder separator separatorBuilder: () -> S
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: componentBuilder(),
            count: nil,
            separator: separatorBuilder()
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
    /// let list = List(count: 2) {
    ///     One(.digit)
    ///     Optionally(", ")
    /// } separator: { ", " }
    /// let output = data
    ///     .wholeMatch(of: regex)
    ///     .map(\.output) // ["1", "2"]
    /// ```
    ///
    /// - Parameters:
    ///   - count: The number of times to repeat `component`. If `count`
    ///     isn't greater than zero `component` will be repeated as many
    ///     times as possible.
    ///   - component: A builder closure that creates the regex
    ///     component to repeat.
    ///   - separator: A builder closure that creates the regex
    ///     component that joins all the `component` occurrences.
    init<C: RegexComponent, S: RegexComponent>(
        count: Int? = nil,
        @RegexComponentBuilder component componentBuilder: () -> C,
        @RegexComponentBuilder separator separatorBuilder: () -> S
    ) where Output == [C.RegexOutput] {
        self.regex = ComponentList(
            component: componentBuilder(),
            count: count,
            separator: separatorBuilder()
        )
        .regex
    }
}
