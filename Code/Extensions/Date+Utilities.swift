//
//  Date+Utilities.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation

extension Date {
    func addingDays(_ days: Int) -> Date {
        return addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
}
