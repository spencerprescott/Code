//
//  NavigationBar.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit

final class NavigationBar: UINavigationBar {
    private let separatorLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup bar colors
        backgroundColor = .white
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        tintColor = .black
        
        // Add separator layer
        separatorLayer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        layer.addSublayer(separatorLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorLayer.frame = CGRect(x: 0, y: bounds.maxY, width: bounds.size.width, height: 1)
    }
}
