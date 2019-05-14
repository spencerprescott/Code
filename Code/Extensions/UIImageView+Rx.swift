//
//  UIImageView+Rx.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension Reactive where Base: UIImageView {
    var url: Binder<URL?> {
        return Binder(base) { imageView, url in
            imageView.kf.setImage(with: url)
        }
    }
}
