//
//  OverviewViewController.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Outlet Collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: Notification.Name("CellsLoaded"), object: nil)
    }
    
    @objc func reloadViews() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellController.sharedInstance.tableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? MenuTableViewCell else {return UITableViewCell()}
        let myCell = CellController.sharedInstance.tableView[indexPath.row]
        cell.menuButton.setImage(myCell.icon, for: .normal)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellController.sharedInstance.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        let myCell = CellController.sharedInstance.cells[indexPath.row]
        if CellController.sharedInstance.currIndex == 0 {
            cell.iconImage.alpha = 0.2
        }
        cell.iconImage.image = myCell.icon
        
        return cell
    }
}
