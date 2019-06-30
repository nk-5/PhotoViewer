//
//  PhotoStreamViewModel.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/29.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class PhotoStreamViewModel {
    private let disposeBag = DisposeBag()
    private let photozouAPIClient: PhotozouAPIProtocol

    init(searchText: Observable<String?>,
         photoView: Reactive<UITableView>,
         dataSources: RxTableViewSectionedReloadDataSource<SectionOfImageData>,
         photozouAPIClient: PhotozouAPIProtocol = PhotozouAPI()) {
        self.photozouAPIClient = photozouAPIClient

        let response = searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter {($0 ?? "").count > 0}
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest {
                photozouAPIClient.getImages(with: $0!, 20).catchErrorJustReturn(Response.empty)
            }
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: Response.empty)

        response
            .filter { $0.info != nil }
            .map {
                var images: [Image] = []
                var shouldStore = true
                var storeThumbnailCount = 2
                for (idx, photo) in $0.info!.photo.enumerated() {
                    if !shouldStore {
                        shouldStore = true
                        continue
                    }

                    var img: [UIImage?] = []
                    do {
                        guard let url: URL = URL(string: photo.imageUrl) else { continue }
                        let imgData: Data = try Data(contentsOf: url)
                        img.append(UIImage(data: imgData))

                        //                        if $0.info!.photo.count > idx+1 && (idx == 0 || !((idx+1) % 5 == 0)) {
                        if $0.info!.photo.count > idx+1 && (idx == 0 || storeThumbnailCount > 0) {
                            guard let nextUrl: URL = URL(string: $0.info!.photo[idx+1].imageUrl) else { continue }
                            let nextImgData: Data = try Data(contentsOf: nextUrl)
                            img.append(UIImage(data: nextImgData))
                        }
                    } catch {
                        // TODO: set no image
                        // image url's http status is 400 or 500
                        if img.count == 0 {
                            continue
                        }
                    }

                    var image: Image = Image()
                    if images.count != 0 && storeThumbnailCount == 0 {
                        image.fullImageURL = img[0]
                        storeThumbnailCount = 2
                    } else {
                        image.thumbnailURLs = img
                        shouldStore = false
                        storeThumbnailCount-=1
                    }
                    images.append(image)
                }

                return [SectionOfImageData(items: images)]

            }
            .drive(photoView.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
