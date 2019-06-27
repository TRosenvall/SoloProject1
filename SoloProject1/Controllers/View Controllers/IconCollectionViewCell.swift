//
//  IconCollectionViewCell.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

protocol IconButtonTappedDelegate: class {
    func iconButtonTappedCell(_ sender: IconCollectionViewCell, menuTapped: Bool)
}

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconCell: UIButton!
    
    weak var delegate: IconButtonTappedDelegate?
    
    @IBAction func iconCellTapped(_ sender: Any) {
        if let assignedDelegate = delegate {
            let menuTapped = CellController.sharedInstance.menuButtonTapped
            assignedDelegate.iconButtonTappedCell(self, menuTapped: menuTapped)
        }
    }
    
    
}
