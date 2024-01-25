# swift-regex

Swift Regex is a Swift package that consists of a set of tools developed to work with Apple's [RegexBuilder][regex-builder] framework more easily.

## Table of content

- [Motivation](#motivation)
- [Components](#components)
  - [List](#list)

## Motivation

This repository originated from experimentation with RegexBuilder during the parsing of inputs for [Advent of Code][AoC] problems. After using the framework for some time, I observed its complexity and verbosity relative to alternatives like [Pointfree][pointfree]'s [swift-parsing]. In fact, Pointfree has an [episode][parsing-vs-regex] that provides a comparison of these parsing techniques, which I recommend watching. Consequently, I decided to start this repository to incorporate helpers and custom components aimed at enhancing the ease and usability of RegexBuilder.

## Components

### List
The `List` component directly matches the number of occurrences for a given component into an array.

Imagine we want to parse some team data mapping its available and injured players:

```swift
let data = """
1: Bob, Alice | John, Molly
"""

struct Team {
    let id: Int
    let availablePlayers: [String]
    let injuredPlayers: [String]
}
```

Parsing the inner name lists would mean to perform a first match capturing them as strings and then perform a second match to parse the players out of them. Using the `List` component it can be directly done since its output is an actual array.

The regex expression representing the data is the following:

```swift
let list = List(
   OneOrMore(.word),
   separator: ", "
)
        
let regex = Regex {
    TryCapture(One(.digit)) { Int($0) }
    ": "
    Capture(list) { $0.map(String.init) }
    " | "
    Capture(list) { $0.map(String.init) }
}
```

And we could match the string using the regular matching API:

```swift
let team = data
    .wholeMatch(of: regex)
    .map { ($0.output.1, $0.output.2, $0.output.3) }
    .map(Team.init)
```

[AoC]: https://adventofcode.com
[regex-builder]: https://developer.apple.com/documentation/regexbuilder
[pointfree]: https://www.pointfree.co
[swift-parsing]: https://github.com/pointfreeco/swift-parsing
[parsing-vs-regex]: https://www.pointfree.co/collections/tours/parser-printers/ep186-tour-of-parser-printers-vs-swift-s-regex-dsl
