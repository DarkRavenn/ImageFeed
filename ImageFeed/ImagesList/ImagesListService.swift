//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 29.08.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImageListProviderDidChange")
    
    private var isActiveArrayPhoto = false
    
    private (set) var photos: [Photo] = []
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let snakeCaseJSONDecoder = SnakeCaseJSONDecoder()
    private let tokenStorage = OAuth2TokenStorage()
    
    private lazy var dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        print("Проверяем наличие активной загрузки")
        if task == nil {
            let nextPage = (lastLoadedPage ?? 0) + 1
            print(nextPage)
            print("Активной загрузки нет погнали")
            fetchArrayPhoto(page: nextPage) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                switch result {
                case.success(let arrayPhoto):
                    self.lastLoadedPage = nextPage
                    for photo in arrayPhoto {
//                        DispatchQueue.main.async() {
                            self.photos.append(Photo(id: photo.id,
                                                size: CGSize(width: photo.width,
                                                             height: photo.height),
                                                createdAt: self.dataFormatter.date(from: photo.createdAt),
                                                welcomeDescription: photo.description,
                                                thumbImageURL: photo.urls.thumb,
                                                largeImageURL: photo.urls.full,
                                                isLiked: photo.likedByUser))
//                        }
                    }
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeNotification,
                              object: self,
                              userInfo: ["Photo": photos])
                    // TODO: Удали дебажный коммент 👇
//                    print("""
//                          id: \(photos[0].id)
//                          size: \(photos[0].size)
//                          createdAt: \(photos[0].createdAt ?? Date())
//                          welcomeDescription: \(photos[0].welcomeDescription ?? "Сервер сказал что его нет")
//                          thumbImageURL: \(photos[0].thumbImageURL)
//                          largeImageURL: \(photos[0].largeImageURL)
//                          isLiked: \(photos[0].isLiked)
//                          """)
                case.failure:
                    break
                }
            }
        } else {
            print("Есть активная загрузка отказать")
        }
    }
}

extension ImagesListService {
    private func makeMeRequest(page: Int) -> URLRequest? {
        guard
            let baseURL = Constants.defaultBaseApiURL,
            let token = tokenStorage.token
        else {
            print("ProfileService.swift [35] Constants.defaultBaseApiURL = nil or tokenStorage.token")
            return nil
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = UnsplashApiPath.photos
        
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "2"),
        ]

        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            print("ProfileService.swift [52] url = components?.url = nil")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchArrayPhoto(page: Int, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        assert(Thread.isMainThread)
        guard isActiveArrayPhoto == false else {
            print("[fetchProfile]: попытка отправить запрос при наличии активного запроса")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        isActiveArrayPhoto = true
        
        guard
            let request = makeMeRequest(page: page)
        else {
            print("[makeMeRequest]: Optional binding = nil")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("[urlSession.objectTask]: \(error)")
                completion(.failure(error))
            }
            self?.task = nil
            self?.isActiveArrayPhoto = false
        }
        self.task = task
        task.resume()
    }
}
