//
//  HistorianHysteria.swift
//  AdventOfCode2024
//
//  Created by Isaías Santana on 01/12/24.
//

struct HistorianHysteria {
    func solve() async {
        print("Distance is ", await caculateDistance())
        print("Similarity score is", await calculateSimilarityScore())
    }

    private func calculateSimilarityScore() async -> Int {
        var score = 0

        let lists = await createLists()

        guard lists.0.count == lists.1.count else {
            return -1
        }

        var similarities: [Int: Int] = [:]

        for location in lists.1 {
            similarities[location] = similarities[location, default: 0] + 1
        }

        for location in lists.0 {
            score += similarities[location, default: 0] * location
        }

        return score
    }

    private func caculateDistance() async -> Int {
        var distance = 0

        let lists = await createLists()

        guard lists.0.count == lists.1.count else {
            return -1
        }

        for index in 0..<lists.0.count {
            let difference = abs(lists.0[index] - lists.1[index])
            distance += difference
        }
        
        return distance
    }

    private func createLists() async -> ([Int], [Int]) {
        var list1: [Int] = []
        var list2: [Int] = []

        for await line in readTestCases() {
            let numbers = line.split(separator: " ").compactMap { Int($0) }

            guard numbers.count == 2 else {
                continue
            }

            list1.append(numbers[0])
            list2.append(numbers[1])
        }

        return (list1.sorted(), list2.sorted())
    }

    private func readTestCases() -> AsyncStream<String> {
        AsyncStream { continuation in
            guard let url = FileReader.url(forResource: "puzzle1") else {
                continuation.finish()
                return
            }

            Task {
                for try await line in url.lines {
                    continuation.yield(String(line))
                }
                continuation.finish()
            }
        }
    }
}
