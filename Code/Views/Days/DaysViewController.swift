//
//  DaysViewController.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import SnapKit

final class DaysViewController: ViewController {
    private let PhotoCellReuseIdentifier = "PhotoCellReuseIdentifier"
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: .vertical)
        v.delegate = self
        v.isPagingEnabled = true
        v.backgroundColor = .white
        v.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCellReuseIdentifier)
        return v
    }()
    
    private let viewModel: DaysViewModelType
    
    init(viewModel: DaysViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.output.photos
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: PhotoCellReuseIdentifier, cellType: PhotoCollectionViewCell.self)) { _, viewModel, cell in
                cell.update(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.currentDay
            .asDriver(onErrorJustReturn: nil)
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // Fire off that we've started on page one
        viewModel.input.currentIndex.onNext(0)
    }
}

extension DaysViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else { return }
        viewModel.input.currentIndex.onNext(indexPath.item)
    }
    
}
