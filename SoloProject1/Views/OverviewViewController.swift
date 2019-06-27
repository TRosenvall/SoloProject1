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
    @IBOutlet weak var numberOfResources: UILabel!
    
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
        cell.menuButton.setImage(myCell.icon.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellController.sharedInstance.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        let myCell = CellController.sharedInstance.cells[indexPath.row]
        cell.iconCell.setImage(myCell.icon.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        cell.delegate = self
        return cell
    }
    
}

extension OverviewViewController: MenuButtonTappedDelegate {
    func menuButtonTappedCell(_ sender: MenuTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let cell = CellController.sharedInstance.tableView[indexPath.row]
        CellController.sharedInstance.lastMenuCellTapped = cell
        CellController.sharedInstance.menuButtonTapped = true
    }
}

extension OverviewViewController: IconButtonTappedDelegate {
    func iconButtonTappedCell(_ sender: IconCollectionViewCell, menuTapped: Bool) {
        guard let indexPath = collectionView.indexPath(for: sender) else {return}
        let cell = CellController.sharedInstance.cells[indexPath.row]
        guard let currResources = numberOfResources.text else {return}
        let maybeResources = Int(currResources)
        guard let firmResources = maybeResources else {return}
        var resources = firmResources
        if menuTapped == true {
            if resources >= CellController.sharedInstance.lastMenuCellTapped.cost {
                if !CellController.sharedInstance.sameCell(lhs: CellController.sharedInstance.cells[indexPath.row], rhs: CellController.sharedInstance.lastMenuCellTapped) {
                resources -= CellController.sharedInstance.lastMenuCellTapped.cost
                numberOfResources.text = "\(resources)"
                CellController.sharedInstance.cells[indexPath.row] = CellController.sharedInstance.lastMenuCellTapped
                }
            }
            CellController.sharedInstance.menuButtonTapped = false
        } else {
            resources += cell.rate
            numberOfResources.text = "\(resources)"
        }
        for x in 0...CellController.sharedInstance.tableView.count - 1{
            let currCell = CellController.sharedInstance.tableView[x]
            if resources < currCell.cost {
                CellController.sharedInstance.tableView[x] = CellController.sharedInstance.tableViewShadow[x]
            } else {
                CellController.sharedInstance.tableView[x] = CellController.sharedInstance.tableViewLight[x]
            }
        }
        tableView.reloadData()
    }
}
