//
//  ViewModel.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

final class ViewModel {
    let imageStore: ImageStore
    private let getCharacter: CharacterHandler
    private(set) var characters: [Character] = []
    private var taskCharacters: URLSessionTask? = nil

    init(imageStore: ImageStore,
        getCharacter:@escaping CharacterHandler) {
        self.imageStore = imageStore
        self.getCharacter = getCharacter
    }

    func getCharacters(completion:@escaping (Result<Void,Error>) -> Void) {
        taskCharacters?.cancel()
        taskCharacters = getCharacter { [weak self] result in
            completion( Result {
                switch result {
                case .success((let data, let response)):
                    guard let characters = try? CharacterMapper.map(data: data, response: response) else {
                        return
                    }
                    self?.characters = characters
                    break
                case .failure(let error):
                    throw error

                }
            })
        }
    }
}
