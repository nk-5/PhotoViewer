//
//  PhotoStream2ViewController.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/27.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PhotoStreamViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var photoView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var viewModel: PhotoStreamViewModel?
    private let disposeBag = DisposeBag()

    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfImageData>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true

        let input = searchField.rx.controlEvent(.editingChanged)
            .map { self.searchField.text }

        let full = UINib(nibName: "FullImageCell", bundle: nil)
        photoView.register(full, forCellReuseIdentifier: "full")

        let thumbnail = UINib(nibName: "ThumbnailImageCell", bundle: nil)
        photoView.register(thumbnail, forCellReuseIdentifier: "thumbnail")

        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfImageData>(
            configureCell: { _, tableView, indexPath, item in

                if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
                    guard let cell: FullImageCell =
                        tableView.dequeueReusableCell(withIdentifier: "full", for: indexPath) as? FullImageCell
                        else { return UITableViewCell() }
                    cell.fullImageView.image = item.fullImageURL
                    return cell
                }

                guard let cell: ThumbnailImageCell =
                    tableView.dequeueReusableCell(withIdentifier: "thumbnail", for: indexPath) as? ThumbnailImageCell
                    else { return UITableViewCell() }
                cell.leftImage.image = item.thumbnailURLs[0]
                if item.thumbnailURLs.count == 2 {
                    cell.rightImage.image = item.thumbnailURLs[1]
                }

                return cell
        })
        self.dataSource = dataSource

        viewModel = PhotoStreamViewModel(searchText: input,
                                         loading: loadingIndicator.rx,
                                         photoView: photoView.rx,
                                         dataSources: dataSource
        )

        photoView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
            return 400
        }
        return 200
    }
}
