//
//  IssueComment.swift
//  IssueTracker
//
//  Created by 송민관 on 2020/11/09.
//

import Foundation

struct IssueComment: Codable {
    let comments: [Comment]
    let counts: Int
}