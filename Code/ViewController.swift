//
//  ViewController.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let service = FlickrPhotoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let min = Date().addingTimeInterval(-3*24*60*60)
        let max = Date()
        service.searchPhotos(dateRange: DateRange(min: min, max: max)) { result in
            
        }
    }
}

