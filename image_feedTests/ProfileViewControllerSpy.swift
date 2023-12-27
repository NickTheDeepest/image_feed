//
//  ProfileViewControllerSpy.swift
//  image_feedTests
//
//  Created by Никита on 26.12.2023.
//

@testable import image_feed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: image_feed.ProfilePresenterProtocol
    var avatarImage: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var loginLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var update: Bool = false
    var views: Bool = false
    var constraints: Bool = false
    var alert: Bool = false
    
    init (presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func updateAvatar() {
        update = true
    }
    
    func configView() {
        views = true
    }
    
    func makeConstraints() {
        constraints = true
    }
    
    func showAlert() {
        presenter.logout()
    }
    
    func showLogoutAlert() {
        alert = true
    }
}
