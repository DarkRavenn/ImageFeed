//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 16.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    // MARK: - Private Properties
    private var isActiveProfileRequests = false
    
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let snakeCaseJSONDecoder = SnakeCaseJSONDecoder()
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Private Methods
    private func makeMeRequest() -> URLRequest? {
        guard 
            let baseURL = Constants.defaultBaseApiURL,
            let token = tokenStorage.token
        else {
            print("ProfileService.swift [35] Constants.defaultBaseApiURL = nil or tokenStorage.token")
            return nil
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = UnsplashApiPath.me
        
        guard let url = components?.url else {
            print("ProfileService.swift [52] url = components?.url = nil")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }    
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard isActiveProfileRequests == false else {
            print("[fetchProfile]: попытка отправить запрос при наличии активного запроса")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        isActiveProfileRequests = true
        
        guard
            let request = makeMeRequest()
        else {
            print("[makeMeRequest]: Optional binding = nil")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                let profile = Profile(firstName: data.firstName,
                                      lastName: data.lastName ?? "",
                                      username: data.username,
                                      bio: data.bio ?? "")
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error): 
                print("[urlSession.objectTask]: \(error)")
                completion(.failure(error))
            }
            self?.task = nil
            self?.isActiveProfileRequests = false
        }
        self.task = task
        task.resume()
    }
}
