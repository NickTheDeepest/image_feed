//
//  ProfileServices.swift
//  image_feed
//
//  Created by Никита on 19.12.2023.
//

import Foundation
import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeRequest(token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let decodedObject):
                let profile = Profile(data: decodedObject)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(DefaultBaseURL)" + "/me") else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func clean() {
        profile = nil
        task?.cancel()
        task = nil
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Codable {
    var userName: String
    var name: String
    var loginName: String
    var bio: String?
    
    init(data: ProfileResult) {
        self.userName = data.username
        self.name = (data.firstName) + " " + (data.lastName ?? "")
        self.loginName = "@" + (data.username)
        self.bio = data.bio
    }
}
