//
//  FullImage.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/29.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import SwiftIconFont

class FullImageCell: UITableViewCell {
    @IBOutlet weak var fullImageView: UIImageView!

    override func awakeFromNib() {
        fullImageView.setIcon(from: .fontAwesome, code: "image")
    }
}
