//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 21.08.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private init() {}
    
    // MARK: - Private Properties
    private var isActiveProfileRequests = false
    
    private (set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let snakeCaseJSONDecoder = SnakeCaseJSONDecoder()
    private let tokenStorage = OAuth2TokenStorage()
    private var profileService = ProfileService.shared
    
    // MARK: - Private Methods
    private func makeMeRequest() -> URLRequest? {
        guard
            let baseURL = Constants.defaultBaseApiURL,
            let token = tokenStorage.token,
            let userName = profileService.profile?.username
        else {
            print("ProfileImageService [31] Constants.defaultBaseApiURL = nil or tokenStorage.token")
            return nil
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = UnsplashApiPath.users + "/\(userName)"
        guard let url = components?.url else {
            print("ProfileImageService [39] url = components?.url = nil")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //TODO: удалить дебажные коментны 👇
        print(token)
        return request
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void){
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
                    let responce = try self.snakeCaseJSONDecoder.decode(UserResult.self, from: data)
                    let avaratURL = responce.profileImage.small
                    self.avatarURL = avaratURL
                    completion(.success(avaratURL))
                    NotificationCenter.default
                        .post(name: ProfileImageService.didChangeNotification,
                              object: self,
                              userInfo: ["URL": avaratURL])
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
