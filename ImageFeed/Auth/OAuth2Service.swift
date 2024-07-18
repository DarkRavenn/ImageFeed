//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 14.07.2024.
//

import Foundation

final class OAuth2Service {
    private let tokenStorage = OAuth2TokenStorage()
    private let snakeCaseJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    static let shared = OAuth2Service()
    private init() {}

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            preconditionFailure("Unable to construct OAuth token request")
        }

        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try self.snakeCaseJSONDecoder.decode(AccessTokenResponse.self, from: data)
                    self.tokenStorage.token = response.accessToken
                    completion(.success(response.accessToken))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error): completion(.failure(error))
                print(error)
            }
        }.resume()
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("OAuth2Service.swift [39] URL(string: \"https://unsplash.com\") = nil")
            return nil
        }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/oauth/token"

        let queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        components?.queryItems = queryItems

        guard let url = components?.url else {
            print("OAuth2Service.swift [57] url = components?.url = nil")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
