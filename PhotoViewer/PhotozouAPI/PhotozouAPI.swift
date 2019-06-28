//
//  PhotozouAPI.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/28.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol PhotozouAPIProtocol {
    func getImages(with searchWord: String, _ limit: Int) -> Observable<Response>
}

enum Errors: Error {
    case requestFailed
}

struct Response: Codable {
    var info: Info

    struct Info: Codable {
        var photoNum: Int
        var photo: [Photo]
    }

    struct Photo: Codable {
        var photoId: Int
        var userId: Int
        var albumId: Int
        var photoTitle: String
        var favoriteNum: Int
        var commentNum: Int
        var viewNum: Int
        var copyright: String
        var originalHeight: Int
        var originalWidth: Int
        var date: String
        var registTime: String
        var url: String
        var imageUrl: String
        var originalImageUrl: String
        var thumbnailImageUrl: String
        var largeTag: String
        var mediumTag: String
    }

    //    static let empty = Response(info: Response.Info)
}

class PhotozouAPI: PhotozouAPIProtocol {
    private var session: SessionManager
    private var baseURL: String
    private var disposeBag: DisposeBag

    init() {
        self.session = SessionManager.default
        self.baseURL = "https://api.photozou.jp/rest/search_public.json"
        self.disposeBag = DisposeBag()
    }

    func getImages(with searchWord: String, _ limit: Int) -> Observable<Response> {
        return Observable.create { [weak self] observer in
            self?.session.rx.request(.get, self!.baseURL, parameters: [
                "keyword": searchWord,
                "limit": String(limit)])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON()
                .subscribe(onNext: {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let res = try? jsonDecoder.decode(Response.self, from: $0.data!) else {
                        observer.onError(Errors.requestFailed)
                        return
                    }
                    observer.onNext(res)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self!.disposeBag)

            return Disposables.create()
        }
    }
}
