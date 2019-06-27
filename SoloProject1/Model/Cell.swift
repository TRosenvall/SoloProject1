//
//  Cell.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class Cell {
    let icon: UIImage
    let rate: Int
    let cost: Int
    
    init( icon: UIImage, rate: Int, cost: Int = 0 ) {
        self.icon = icon
        self.rate = rate
        self.cost = cost
    }
}
