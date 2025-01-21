//
//  LocationStore.swift
//  testproj
//
//  Created by marlon von ansale on 05/01/2025.
//

import Foundation

final class URLClient {
    private let getHandler: URLHandler

    init(getHandler: @escaping URLHandler) {
        self.getHandler = getHandler
    }

    func getURL<T: Decodable>(url: String, complete: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        guard let url = URL(string: url) else {
            complete(Result {
                throw LoadError.invalidURL
            })
            return nil
        }

        return getHandler(url) { result in
            complete(
                Result {
                    switch result {
                    case .success((let data, let httpResponse)):
                        try Mapper.map(data: data, response: httpResponse)
                    case .failure(let failure):
                        throw failure
                    }
                })
        }
    }
}
