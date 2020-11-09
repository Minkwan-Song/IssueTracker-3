//
//  NetworkManager.swift
//  IssueTracker
//
//  Created by ParkJaeHyun on 2020/10/28.
//

import Foundation

protocol NetworkServiceProvider {
    var token: String { get set }
    func request(apiConfiguration: APIConfiguration, handler: @escaping (Result<Data, NetworkError>) -> Void)
}

class NetworkService: NetworkServiceProvider {
    @KeyChain("token", defaultValue: "") var token: String
    private let session: URLSession
    
    init(with urlSession: URLSession = .init(configuration: .default)) {
        session = urlSession
    }
    
    func request(apiConfiguration: APIConfiguration, handler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = try? configureURLRequest(apiConfiguration: apiConfiguration) else {
            print("url 변환 실패")
            handler(.failure(.invalidURL))
            return
        }
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("error")
                handler(.failure(.requestFailure(message: error.localizedDescription)))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(.invalidResponse(message: "")))
                // !200대 / 400 / 500
                print("bad response")
                return
            }
            guard let data = data else {
                print("no data")
                handler(.failure(.invalidData(message: "data nil")))
                return
            }
            handler(.success(data))
        }.resume()
    }
    
    private func configureURLRequest(apiConfiguration: APIConfiguration) throws -> URLRequest {
        let url = try APIServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(apiConfiguration.path))
        // urlRequest.setValue("bearer \(token)", forHTTPHeaderField: "\(HTTPHeader.authentication)")
        urlRequest.httpMethod = "\(apiConfiguration.method)"
        urlRequest.setValue("\(ContentType.json)", forHTTPHeaderField: "\(HTTPHeader.acceptType)")
        // urlRequest.setValue("\(ContentType.json)", forHTTPHeaderField: "\(HTTPHeader.contentType)")
        urlRequest.httpBody = apiConfiguration.body
        return urlRequest
    }
}

//class NetworkManager {
//    let session: SessionManager
//
//    init(sessionManager: SessionManager) {
//        self.session = sessionManager
//    }
//
//    func request(endPoint: URLRequestConvertible, handler: @escaping (Data?) -> Void) {
//        session.request(endPoint, interceptor: nil).response { response in
//            switch response.result {
//            case .success(let response):
//                handler(response)
//            case .failure(let error):
//                os_log("%@", error.localizedDescription)
//            }
//        }
//    }
//}
//
//protocol SessionManager {
//    func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor?) -> DataRequest
//}
//
//extension Session: SessionManager {
//}