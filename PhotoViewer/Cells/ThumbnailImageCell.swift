//
//  ThumbnailImageCell.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/30.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit

class ThumbnailImageCell: UITableViewCell {
    @IBOutlet weak var leftImage: UIImageView!

    @IBOutlet weak var rightImage: UIImageView!

    override func awakeFromNib() {
        leftImage.setIcon(from: .fontAwesome, code: "image")
        rightImage.setIcon(from: .fontAwesome, code: "image")
    }
}
