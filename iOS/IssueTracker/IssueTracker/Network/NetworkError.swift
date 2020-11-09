//
//  NetworkError.swift
//  IssueTracker
//
//  Created by 송민관 on 2020/11/09.
//

import Foundation

enum NetworkError: Error {
    case invalidToken
    case invalidURL
    case requestFailure(message: String)
    case invalidResponse(message: String)
    case invalidData(message: String)
}