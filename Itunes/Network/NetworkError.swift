//
//  NetworkError.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unknownError
    case invalidStatus
    case noData
}
