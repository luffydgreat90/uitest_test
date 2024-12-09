//
//  ViewModel.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

final class ViewModel {
    let imageStore: ImageStore
    private let getCharactersStore: CharacterHandler
    private(set) var characters: [Character] = []
    private var taskCharacters: URLSessionTask? = nil

    init(imageStore: ImageStore,
         getCharacterHttp:@escaping CharacterHandler) {
        self.imageStore = imageStore
        self.getCharactersStore = getCharacterHttp

    }

    func getCharacters(completion:@escaping (Result<Void, Error>) -> Void) {
        
        getCharactersStore { [weak self] result in
            completion( Result {
                switch result {
                case .success(let character):
                    self?.characters = character
                case .failure(let failure):
                    throw failure
                }
            })
        }
    }
}
