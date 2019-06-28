//
//  PhotozouAPITests.swift
//  PhotoViewerTests
//
//  Created by 中川慶悟 on 2019/06/29.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import XCTest
@testable import PhotoViewer

class PhotozouAPITests: XCTestCase {

    private var client: PhotozouAPI = PhotozouAPI()

    override func setUp() {
    }

    func testGetImage() {
        let expectation = self.expectation(description: #function)
        _ = client.getImages(with: "ios", 1)
            .subscribe(onNext: { res in
                XCTAssertEqual(1, res.info.photoNum)
                expectation.fulfill()
            }, onError: { err in
                XCTAssertNil(err)
            })
        waitForExpectations(timeout: 3)
    }
}
