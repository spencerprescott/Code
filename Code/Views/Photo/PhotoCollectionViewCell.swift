//
//  PhotoCollectionViewCell.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class PhotoCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.kf.indicatorType = .activity
        return v
    }()
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        l.textColor = .white
        return l
    }()
    private lazy var contentContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentContainerView.isHidden = true
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(contentContainerView)
        contentContainerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        contentContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.bottom.equalTo(contentContainerView.snp.bottomMargin).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentContainerView.isHidden = true
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
    
    func update(viewModel: PhotoViewModelType) {
        let photo = viewModel.output.photo.share()
        
        photo
            .map { $0?.title }
            .asDriver(onErrorJustReturn: nil)
            .drive(photoTitle)
            .disposed(by: disposeBag)
        
        photo
            .map { $0?.assetUrl }
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.url)
            .disposed(by: disposeBag)
    }
    
    private var photoTitle: Binder<String?> {
        return Binder(self) { view, title in
            view.titleLabel.text = title
            view.contentContainerView.isHidden = title == nil
        }
    }
}
