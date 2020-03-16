//
//  HTTPClient.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

enum Result<T> {

    case success(T)

    case failure(Error)
}

enum GHHTTPClientError: Error {

    case decodeDataFail

    case clientError(Data)

    case serverError

    case unexpectedError
}

enum GHHTTPMethod: String {

    case GET

    case POST
    
    case PUT
}

enum GHHTTPHeaderField: String {

    case contentType = "Content-Type"

    case auth = "Authorization"
}

enum GHHTTPHeaderValue: String {

    case json = "application/json"
}

protocol GHRequest {

    var headers: [String: String] { get }

    var body: Data? { get }

    var method: String { get }

    var endPoint: String { get }
}

extension GHRequest {
    
    func makeRequest() -> URLRequest {

        let urlString = Bundle.GHValueForString(key: GHConstant.urlKey) + endPoint

        let url = URL(string: urlString)!

        var request = URLRequest(url: url)

        request.allHTTPHeaderFields = headers
        
        request.httpBody = body

        request.httpMethod = method

        return request
    }
}

class HTTPClient {

    static let shared = HTTPClient()

    private let decoder = JSONDecoder()

    private let encoder = JSONEncoder()

    private init() { }

    func request(
        _ ghRequest: GHRequest,
        completion: @escaping (Result<Data>) -> Void
    ) {

        URLSession.shared.dataTask(
            with: ghRequest.makeRequest(),
            completionHandler: { (data, response, error) in

            guard error == nil else {

                return completion(Result.failure(error!))
            }
                
            // swiftlint:disable force_cast
            let httpResponse = response as! HTTPURLResponse
            // swiftlint:enable force_cast
            let statusCode = httpResponse.statusCode

            switch statusCode {

            case 200..<300:

                completion(Result.success(data!))

            case 400..<500:

                completion(Result.failure(GHHTTPClientError.clientError(data!)))

            case 500..<600:

                completion(Result.failure(GHHTTPClientError.serverError))

            default: return

                completion(Result.failure(GHHTTPClientError.unexpectedError))
            }

        }).resume()
    }
}
