//
//  WebViewViewControllerSpy.swift
//  image_feed
//
//  Created by Никита on 26.12.2023.
//
import image_feed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: image_feed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
