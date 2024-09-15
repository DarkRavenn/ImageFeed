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
    
    // MARK: - Public Methods
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        guard isActiveProfileRequests == false else {
            print("[fetchProfileImageURL]: попытка отправить запрос при наличии активного запроса")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        isActiveProfileRequests = true
        
        guard
            let request = makeUsersRequest()
        else {
            print("[makeUsersRequest]: Optional binding = nil")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                let avaratURL = data.profileImage.small
                self?.avatarURL = avaratURL
                completion(.success(avaratURL))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": avaratURL])
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
    
    func cleanavatarURL() {
        avatarURL = nil
    }
    
    // MARK: - Private Methods
    private func makeUsersRequest() -> URLRequest? {
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
        return request
    }
}
