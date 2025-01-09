//
//  LocationDetail.swift
//  testproj
//
//  Created by marlon von ansale on 09/01/2025.
//

import Foundation

struct LocationDetail: Decodable {
    let name: String
    let url: String
    let type: String
    let residents: [String]
}

