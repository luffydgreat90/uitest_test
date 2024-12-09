//
//  LoadError.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import Foundation

enum LoadError: Error {
    case invalidData
    case invalidURL
    case httpError
}
