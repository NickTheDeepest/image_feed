//
//  ImagesListService.swift
//  image_feed
//
//  Created by Никита on 23.12.2023.
//

import Foundation
import UIKit

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private let storageToken = OAuth2TokenStorage()
    private let dateFormatter = ISO8601DateFormatter()
    
    private init() {}

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        let page = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        guard let request = photoRequest(page: String(page), perPage: "10") else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                self.task = nil
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(self.convert(photoResult))
                    }
                    self.lastLoadedPage = page
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Images" : self.photos])
                case .failure(_):
                    break
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func photoRequest(page: String, perPage: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: url)
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func convert(_ photoResult: PhotoResult) -> Photo {
        Photo(id: photoResult.id,
              width: CGFloat(photoResult.width),
              height: CGFloat(photoResult.height),
              createdAt: self.dateFormatter.date(from:photoResult.createdAt ?? "Error"),
              welcomeDescription: photoResult.welcomeDescription,
              thumbImageURL: photoResult.urls?.thumbImageURL ?? "Error",
              largeImageURL: photoResult.urls?.largeImageURL ?? "Error",
              isLiked: photoResult.isLiked ?? false)
    }

    func updatePhotos(_ photos: [Photo]) {
        self.photos = photos
    }

    func clean() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()

        guard let token = storageToken.token else { return }
        var request: URLRequest?
//        if isLike {
//            request = deleteLikeRequest(token, photoId: photoId)
//        } else {
//            request = postLikeRequest(token, photoId: photoId)
//        }
        request = isLike ? deleteLikeRequest(token, photoId: photoId) : postLikeRequest(token, photoId: photoId)
        guard let request = request else { return }
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoIsLiked, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                let isLiked = photoResult.photo?.isLiked ?? false
                if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo?.id }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        width: photo.width,
                        height: photo.height,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: isLiked
                    )
                    self.photos = self.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }

    private func postLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestPost = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "POST",
            baseURL: URL(string: "\(DefaultBaseURL)")!)
        requestPost.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestPost
    }

    private func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }

    private func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestDelete = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "DELETE",
            baseURL: URL(string: "\(DefaultBaseURL)")!)
        requestDelete.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestDelete
    }
}

struct Photo {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: urlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
    }
}

struct urlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct PhotoIsLiked: Decodable {
    let photo: PhotoResult?
}


