//
//  Mapper.swift
//  testproj
//
//  Created by marlon von ansale on 09/01/2025.
//

import Foundation

enum Mapper {
    static func map<T: Decodable>(data: Data?, response: HTTPURLResponse) throws -> T {
        guard let data = data, response.statusCode == 200 else {
            throw LoadError.invalidData
        }

        let character = try JSONDecoder().decode(T.self, from: data)

        return character
    }
}
