//
//  CreateIssueInteractor.swift
//  IssueTracker
//
//  Created by 송민관 on 2020/11/08.
//

import Foundation

protocol CreateIssueDataStore {
    var createdIssue: Issue? { get set }
}

protocol CreateIssueBusinessLogic {
    func uploadIssue(title: String, comment: String)
}

final class CreateIssueInteractor: CreateIssueDataStore {
    let networkService: NetworkServiceProvider = NetworkService()
    var presenter: IssueListPresentationLogic?
    var createdIssue: Issue?
    var issueID: Int?
    
    private func createIssue(title: String, comment: String) -> Issue {
        return Issue(title: title, body: comment)
    }
}

extension CreateIssueInteractor: CreateIssueBusinessLogic {
    func uploadIssue(title: String, comment: String) {
        guard let data = try? createdIssue?.encoded() else {
            // Error 처리
            return
        }
        networkService.request(apiConfiguration: CreateIssueEndPoint.upload(data)) { [weak self] result in
            switch result {
            case .failure(_):
                print("create issue 실패")
                // Error 처리
                return
            case .success(let data):
                guard let decodedData: Int = try? data.decoded() else {
                    print("upload response decode 실패")
                    return
                }
                self?.issueID = decodedData
                
                return
            }
        }
        // patch - label 등 나머지
    }
    
    func uploadIssueComponents() {
        
    }
}

//guard (200...299).contains() else {
//    result.send(completion: .failure(.error(message: "\(httpResponse.statusCode)")))
//    return
//}
//guard (400...499).contains(response)
