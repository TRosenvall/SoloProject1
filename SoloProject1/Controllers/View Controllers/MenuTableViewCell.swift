//
//  MenuTableViewCell.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

protocol MenuButtonTappedDelegate: class {
    func menuButtonTappedCell(_ sender: MenuTableViewCell)
}

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuButton: UIButton!
    
    weak var delegate: MenuButtonTappedDelegate?
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if let assignedDelegate = delegate {
            assignedDelegate.menuButtonTappedCell(self)
        }
    }
}
