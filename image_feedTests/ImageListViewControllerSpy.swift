//
//  ImageListViewControllerSpy.swift
//  image_feedTests
//
//  Created by Никита on 27.12.2023.
//

import Foundation
@testable import image_feed
import UIKit

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: image_feed.ImagesListPresenterProtocol?
    var photos: [image_feed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.checkCompletedList(indexPath)
    }

    func setLike() {
        presenter?.setLike(photoId: "some", isLike: true)
        {[weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTableViewAnimated() {
    }
}
