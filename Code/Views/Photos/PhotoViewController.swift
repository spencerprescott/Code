//
//  PhotoViewController.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoViewController: ViewController {
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.kf.indicatorType = .activity
        return v
    }()
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        l.textColor = .black
        return l
    }()
    
    private let service = FlickrPhotoService()
    
    private let viewModel: PhotoViewModelType
    
    init(viewModel: PhotoViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        super.setupBindings()        
        let photo = viewModel.output.photo.share()
        
        photo
            .map { $0?.title }
            .asDriver(onErrorJustReturn: nil)
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        photo
            .map { $0?.assetUrl }
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.url)
            .disposed(by: disposeBag)
    }
}
