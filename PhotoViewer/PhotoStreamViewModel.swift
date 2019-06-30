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
                photozouAPIClient.getImages(with: $0!, 10).catchErrorJustReturn(Response.empty)
            }
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: Response.empty)

        response.map {
            var images: [Image] = []
            for photo in $0.info!.photo {
                images.append(Image(imageURL: photo.imageUrl))
            }

            return [SectionOfImageData(items: images)]

            }
            .drive(photoView.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
