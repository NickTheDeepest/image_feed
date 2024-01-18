//
//  ProfilePresenterSpy.swift
//  image_feedTests
//
//  Created by Никита on 26.12.2023.
//

@testable import image_feed
import Foundation
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var profileService: image_feed.ProfileService
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var didLogoutCalled: Bool = false
    var clean: Bool = false
    var observe: Bool = false
    
    init (profileService: ProfileService ) {
        self.profileService = profileService
    }
    
    func updateProfileDetails(profile: Profile?) {
        view?.configView()
        view?.makeConstraints()
    }
    
    func observeAvatarChanges() {
        observe = true
    }
    
    func logout() {
        didLogoutCalled = true
    }
    
    func cleanServicesData() {
        clean = true
    }
    
    func getUrlForProfileImage() -> URL? {
        return URL(string: "\(AuthConfiguration.standard.defaultBaseURL)")
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func makeAlert() -> UIAlertController {
        UIAlertController()
    }
}
