//
//  NetwokErrors.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/23/21.
//

import Foundation

enum NetworkErrors: Error {
    case invalidComponents
    case invalidURL
    case nilData
    case httpError
}
