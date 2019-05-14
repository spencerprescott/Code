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
        l.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        l.textColor = .black
        return l
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
    
    func update(viewModel: PhotoViewModelType) {
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
