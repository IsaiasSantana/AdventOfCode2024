//
//  FileReader.swift
//  AdventOfCode2024
//
//  Created by Isaías Santana on 01/12/24.
//

import Foundation

struct FileReader {
    static func url(forResource name: String) -> URL? {
        guard let url = Bundle.module.url(forResource: name, withExtension: "txt") else {
            return nil
        }
        return url
    }
}
