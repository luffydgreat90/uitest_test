//
//  CharacterStore.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

typealias CharacterHandler  = (@escaping (Result<[Character], Error>) -> Void) -> Void

final class CharacterStore {
    let getHandler: URLHandler
    private var taskCharacters: URLSessionTask? = nil
    
    init(getHandler: @escaping URLHandler) {
        self.getHandler = getHandler
    }

    func getCharacters(complete: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            complete(Result {
                throw LoadError.invalidURL
            })

            return
        }

        taskCharacters?.cancel()
        taskCharacters = getHandler(url) { result in
            complete(
                Result {
                    switch result {
                    case .success((let data, let httpResponse)):
                        try CharacterMapper.map(data: data, response: httpResponse)
                    case .failure(let failure):
                        throw failure
                    }

                })
        }
    }
}
