//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 16.08.2024.
//

import Foundation

protocol ProfileServiceDelegate: AnyObject {
    func show(_ profileDetail: Profile)
}

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    // MARK: - Public Properties
    weak var delegate: ProfileServiceDelegate?
    
    // MARK: - Private Properties
    private var isActiveProfileRequests = false
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let snakeCaseJSONDecoder = SnakeCaseJSONDecoder()
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Public Methods
    func fetchProfile() {
        fetchProfile { result in
            switch result {
            case .success(let profile):
                self.delegate?.show(profile)
            case .failure:
                return
            }
        }
    }
    
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
        print(request)
        return request
    }    
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard isActiveProfileRequests == false else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        isActiveProfileRequests = true
        
        guard
            let request = makeMeRequest()
        else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let responce = try self.snakeCaseJSONDecoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(firstName: responce.firstName,
                                          lastName: responce.lastName,
                                          username: responce.username,
                                          bio: responce.bio ?? "")
                    completion(.success(profile))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error): completion(.failure(error))
                print(error)
            }
            self.task = nil
            self.isActiveProfileRequests = false
        }
        self.task = task
        task.resume()
    }
}

