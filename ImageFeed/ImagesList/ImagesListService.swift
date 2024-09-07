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

    private (set) var photos: [Photo] = []
    
    private var isActiveArrayPhoto = false
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let snakeCaseJSONDecoder = SnakeCaseJSONDecoder()
    private let tokenStorage = OAuth2TokenStorage()
    
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        print("Проверяем наличие активной загрузки изображений текущая страница: \(lastLoadedPage ?? 0)")
        if task == nil {
            let nextPage = (lastLoadedPage ?? 0) + 1
            print("Активной загрузки нет, загружаем страницу: \(nextPage)")
            fetchArrayPhoto(page: nextPage) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                
                switch result {
                case.success(let newPhotos):
                    self.lastLoadedPage = nextPage
                    addToPhotos(newPhotos: newPhotos)
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                case.failure:
                    break
                }
            }
        } else {
            print("Есть активная загрузка изображений новый запрос отменен")
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
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
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
    
    private func addToPhotos(newPhotos: [PhotoResult]) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        for photo in newPhotos {
            let newPhoto = Photo(id: photo.id,
                                 size: CGSize(width: photo.width, height: photo.height),
                                 createdAt: dateFormater.date(from: photo.createdAt),
                                 welcomeDescription: photo.description,
                                 thumbImageURL: photo.urls.thumb,
                                 largeImageURL: photo.urls.full,
                                 isLiked: photo.likedByUser
            )
            photos.append(newPhoto)
        }
    }
}
