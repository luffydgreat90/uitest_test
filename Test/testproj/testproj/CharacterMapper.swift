//
//  CharacterMapper.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

enum CharacterMapper {

    private struct Characters: Decodable {
        let results: [Character]
    }

    static func map(data: Data?, response: HTTPURLResponse) throws -> [Character] {
        guard let data = data, response.statusCode == 200 else {
            throw LoadError.invalidData
        }

        let characters = try JSONDecoder().decode(Characters.self, from: data)

        return characters.results
    }
}
