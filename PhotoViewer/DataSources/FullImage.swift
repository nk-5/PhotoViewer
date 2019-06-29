//
//  FullImage.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/29.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxDataSources

struct FullImage {
    var image: String
    //    var image: UIImageView
}

struct SectionOfImageData {
    var items: [Item]
}

extension SectionOfImageData: SectionModelType {
    typealias Item = FullImage

    init(original: SectionOfImageData, items: [Item]) {
        self = original
        self.items = items
    }
}
