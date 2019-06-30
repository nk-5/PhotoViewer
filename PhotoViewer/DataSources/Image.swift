//
//  FullImage.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/29.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxDataSources

struct Image {
    var fullImageURL: UIImage?
    var thumbnailURLs: [UIImage?]

    init(fullImageURL: UIImage? = nil,
         thumbnailURL: [UIImage?] = []) {
        self.fullImageURL = fullImageURL
        self.thumbnailURLs = thumbnailURL
    }
}

struct SectionOfImageData {
    var items: [Item]
}

extension SectionOfImageData: SectionModelType {
    typealias Item = Image

    init(original: SectionOfImageData, items: [Item]) {
        self = original
        self.items = items
    }
}
