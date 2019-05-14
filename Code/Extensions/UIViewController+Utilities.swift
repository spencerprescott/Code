//
//  UIViewController+Utilities.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    func addContentViewController(_ viewController: UIViewController, constraints: ((ConstraintMaker) -> Void)? = nil) {
        addChild(viewController)
        view.addSubview(viewController.view)
        let closure = constraints ?? { make in
            make.edges.equalToSuperview()
        }
        viewController.view.snp.makeConstraints(closure)
        viewController.didMove(toParent: self)
    }
}
