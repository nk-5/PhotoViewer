//
//  PhotoStream2ViewController.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/27.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit

//class PhotoStreamViewController: UITableViewController {
class PhotoStreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var photoView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.dataSource = self
        photoView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "full", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "thumbnail", for: indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
            return 400
        }
        return 200
    }
}