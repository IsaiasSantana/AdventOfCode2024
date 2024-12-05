//
//  MullItOver.swift
//  AdventOfCode2024
//
//  Created by Isaías Santana on 03/12/24.
//

import Foundation
import RegexBuilder

enum Instruction: String {
    case `do` = "do()"
    case dont = "don't()"
    case mul

    init?(token: String) {
        if token.starts(with: "mul") {
            self = .mul
            return
        }

        if let value = Instruction(rawValue: token) {
            self = value
            return
        }

        return nil
    }
}

struct MullItOver {
    private let mulRegex: Regex = {
        Regex {
            "mul("
            Capture {
                Repeat(1...3) { .digit }
            } transform: { matchedDigits in
                Int(matchedDigits)!
            }
            ","
            Capture {
                Repeat(1...3) { .digit }
            } transform: { matchedDigits in
                Int(matchedDigits)!
            }
            ")"
        }
    }()

    private let dontCommandRegex: Regex = {
        Regex {
            "don't()"
        }
    }()

    private let doCommandRegex: Regex = {
        Regex {
            "do()"
        }
    }()

    func solve() throws {
        try partOne()
        try partTwo()
    }

    private func partOne() throws {
        let input = try readInput()
        
        let result = sumAllMultiplications(for: input)

        print("------------------------------", separator: "\n")
        print("part 1", separator: "\n")
        print("Multiplication sum: \(result)")
        print("------------------------------", separator: "\n")
    }

    private func readInput() throws -> String {
        guard let url = FileReader.url(forResource: "puzzle3") else {
            throw FileReader.InputError.fileNotFound
        }

        return try String(contentsOf: url, encoding: .utf8)
    }

    private func sumAllMultiplications(for input: String) -> Int {
        var sum = 0

        for match in input.matches(of: mulRegex) {
            let (_, x, y) = match.output
            sum += x * y
        }

        return sum
    }

    private func partTwo() throws {
        let result = processInput(try readInput())

        print("------------------------------", separator: "\n")
        print("part 2", separator: "\n")
        print("Multiplication sum: \(result)")
        print("------------------------------", separator: "\n")
    }

    private func processInput(_ input: String) -> Decimal {
        let dontMatches = input.matches(of: dontCommandRegex)
        let mulMatches = input.matches(of: mulRegex)
        let doMatches = input.matches(of: doCommandRegex)

        let ranges = merge(
            range1: merge(range1: mulMatches.map { $0.range }, range2: dontMatches.map { $0.range }),
            range2: doMatches.map { $0.range }
        )


        var shouldExecuteMultiplication = true
        var sum: Decimal = 0

        for range in ranges {
            switch Instruction(token: String(input[range])) {
            case .dont:
                shouldExecuteMultiplication = false

            case .do:
                shouldExecuteMultiplication = true

            case .mul:
                if shouldExecuteMultiplication, let match = input[range].matches(of: mulRegex).first {
                    let (_, x, y) = match.output

                    sum += Decimal(x) * Decimal(y)
                }

            case nil:
                continue
            }
        }

        return sum
    }

    private func merge(range1: [Range<String.Index>], range2: [Range<String.Index>]) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var i = 0
        var j = 0

        while i < range1.count && j < range2.count {
            if range1[i].lowerBound < range2[j].lowerBound {
                result.append(range1[i])
                i += 1
            } else {
                result.append(range2[j])
                j += 1
            }
        }

        while i < range1.count {
            result.append(range1[i])
            i += 1
        }

        while j < range2.count {
            result.append(range2[j])
            j += 1
        }

        return result
    }

}
