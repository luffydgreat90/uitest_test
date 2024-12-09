//
//  CharacterStore.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

typealias CharacterHandler  = (@escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionTask?

class CharacterStore {
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getCharacters(complete: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
    -> URLSessionTask? {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            complete(Result {
                throw LoadError.invalidURL
            })

            return nil
        }

        let task = urlSession.dataTask(with: URLRequest(url:url)) { data, response, error in
            complete(
                Result {
                    if let error = error {
                        throw error
                    }else if let data, let httpResponse = response as? HTTPURLResponse {
                        return (data, httpResponse)
                    }else {
                        throw LoadError.invalidURL
                    }
                }
            )

        }
        task.resume()
        return task
    }
}
