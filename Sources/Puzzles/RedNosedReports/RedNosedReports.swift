//
//  RedNosedReports.swift
//  AdventOfCode2024
//
//  Created by Isaías Santana on 02/12/24.
//

import Foundation

final class RedNosedReports {
    private var reports = [Report]()

    func loadReports() async throws {
        guard let url = FileReader.url(forResource: "puzzle2") else {
            return
        }

        for try await line in url.lines where !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reports.append(
                Report(
                   levels: line.split(separator: " ").compactMap { Int($0) }
               )
            )
        }
    }

    func safeReportsCount() -> Int {
        reports.reduce(0, { (count, report) in
            if report.levelsAreSafeWithoutDampener() {
                return count + 1
            }
            return count
        })
    }
}

extension RedNosedReports {
    struct Report {
        let levels: [Int]

        init(levels: [Int]) {
            self.levels = levels
        }

        func levelsAreSafeWithoutDampener() -> Bool {
            if levelsAreSafe() {
                return true
            }

            for elementToSkip in 0..<levels.count {
                var newLevels = [Int]()

                for (index, level) in levels.enumerated() {
                    if index == elementToSkip {
                        continue
                    }
                    newLevels.append(level)
                }

                let report = Report(levels: newLevels)

                if report.levelsAreSafe() {
                    return true
                }
            }

            return false
        }

        func levelsAreSafe() -> Bool {
            guard levels.count > 1 else {
                return true
            }

            if isIncreasing(firstIndex: 0, secondIndex: 1) {
                return isAllAdjacentsLevelsDiffValid() && isAllLevelsIncreasing()
            }

            if isDecreasing(firstIndex: 0, secondIndex: 1) {
                return isAllAdjacentsLevelsDiffValid() && isAllLevelsDecreasing()
            }

            return false
        }

        private func isAllAdjacentsLevelsDiffValid() -> Bool {
            for index in 0..<levels.count - 1 {
                if isValidDiff(diff: calculateDiff(level1: levels[index], level2: levels[index + 1])) {
                    continue
                }
                return false
            }
            return true
        }

        private func calculateDiff(level1: Int, level2: Int) -> Int {
            abs(level1 - level2)
        }

        private func isValidDiff(diff: Int) -> Bool {
            diff >= 1 && diff <= 3
        }

        private func isAllLevelsIncreasing() -> Bool {
            for index in 0..<levels.count - 1 {
                if isIncreasing(firstIndex: index, secondIndex: index + 1) {
                   continue
                }
                return false
            }
            return true
        }

        private func isAllLevelsDecreasing() -> Bool {
            for index in 0..<levels.count - 1 {
                if isDecreasing(firstIndex: index, secondIndex: index + 1) {
                    continue
                }

                return false
            }
            return true
        }

        private func isIncreasing(firstIndex: Int, secondIndex: Int) -> Bool {
            levels[firstIndex] != levels[secondIndex] && levels[secondIndex] > levels[firstIndex]
        }

        private func isDecreasing(firstIndex: Int, secondIndex: Int) -> Bool {
            levels[firstIndex] != levels[secondIndex] && levels[secondIndex] < levels[firstIndex]
        }
    }
}
