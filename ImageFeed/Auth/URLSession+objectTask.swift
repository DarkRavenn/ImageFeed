//
//  URLSession+objectTask.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 25.08.2024.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                do {
                    let responce = try SnakeCaseJSONDecoder().decode(T.self, from: data)
                    completion(.success(responce))
                } catch (let error) {
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[data]: NetworkError - \(error)")
                completion(.failure(error))
            }
        }
        return task
    }
}
