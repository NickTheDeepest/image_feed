//
//  image_feedTests.swift
//  image_feedTests
//
//  Created by Никита on 23.12.2023.
//

@testable import image_feed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    
//    func testFetchPhotos() {
//        let service = ImagesListService()
//
//        let expecttion = self.expectation(description: "Wait for Notification")
//        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main)  {_ in
//            expecttion.fulfill()
//        }
//
//        service.fetchPhotosNextPage()
//        wait(for: [expecttion], timeout: 10)
//
//        XCTAssertEqual(service.photos.count, 10)
//
//    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
