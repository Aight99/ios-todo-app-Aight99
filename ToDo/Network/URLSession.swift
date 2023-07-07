//
//  URLSession.swift
//  ToDo
//
//  Created by ios_developer on 08.07.2023.
//

import Foundation

enum RequestError: Error {
    case invalidResponse
}

extension URLSession {

    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: RequestError.invalidResponse)
                }
            }
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}
