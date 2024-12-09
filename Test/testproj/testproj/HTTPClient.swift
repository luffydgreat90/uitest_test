//
//  HTTPClient.swift
//  testproj
//
//  Created by marlon von ansale on 09/12/2024.
//

import Foundation

typealias URLHandler = (URL,@escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionTask?

final class HTTPClient {
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func get(url:URL, complete: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionTask? {

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
