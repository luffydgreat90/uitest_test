//
//  ImageStore.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

actor ImageStore {
    private let urlSession: URLSession
    var imageDatas:[URL: Data] = [:]

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func storeDatas(url: URL, data: Data) {
        imageDatas[url] = data
    }

    func getImage(url:URL, completion: @escaping(Result<Data,Error>) -> Void) -> URLSessionTask? {
        if let data = imageDatas[url] {
            completion( Result {
                return data
            })
        }

        let task = urlSession.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
                completion( Result {
                    if let data {
                        Task {
                            await self.storeDatas(url:url,data:data)
                        }

                        return data
                    } else if let error {
                        throw error
                    } else {
                        throw LoadError.httpError
                    }
                })
        }

        task.resume()
        return task
    }
}
