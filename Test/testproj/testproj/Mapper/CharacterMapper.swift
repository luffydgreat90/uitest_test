//
//  CharacterMapper.swift
//  testproj
//
//  Created by marlon von ansale on 05/01/2025.
//

import Foundation

enum CharacterMapper {

    static func map(data: Data?, response: HTTPURLResponse) throws -> Character {
        guard let data = data, response.statusCode == 200 else {
            throw LoadError.invalidData
        }

        let character = try JSONDecoder().decode(Character.self, from: data)

        return character
    }
}
