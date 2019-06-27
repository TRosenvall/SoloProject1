//
//  CellController.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class CellController {
    
    // Singleton
    static let sharedInstance = CellController()
    
    let notification = Notification(name: .init("CellsLoaded"))
    
    var currIndex: Int = 0
    var defaultImage: UIImage = UIImage(named: "blank")!
    lazy var lastMenuCellTapped: Cell = Cell(icon: defaultImage, rate: 1)
    var menuButtonTapped: Bool = false
    
    private init() {
        var tempCellHolding: [Cell] = []
        var tempHolding: [Cell] = []
        var shadowHolding: [Cell] = []
        var finalHolding: [Cell] = []
        var finalShadow: [Cell] = []
        let dg = DispatchGroup()
        for _ in 0...104 {
            dg.enter()
            fetchSearchData(indexNumber: currIndex) { (searchData) in
                guard let unwrappedData = searchData else {dg.leave(); return}
                self.fetchCell(indexNumber: self.currIndex, searchData: unwrappedData, completion: { (cell) in
                    guard let myCell = cell else {dg.leave(); return}
                    tempCellHolding.append(myCell)
                    dg.leave()
                })
            }
        }
        
        for x in 1...15 {
            dg.enter()
            fetchSearchData(indexNumber: x) { (searchData) in
                guard let unwrappedData = searchData else {dg.leave(); return}
                self.fetchCell(indexNumber: x, searchData: unwrappedData, completion: { (cell) in
                    guard let newCell = cell else {dg.leave(); return}
                    let tempCell = Cell(icon: newCell.icon, rate: Int(pow(Double(2), Double(x))), cost: Int(pow(Double(x),Double(x))) )
                    guard let shadowImage = newCell.icon.maskWithColor(color: .black) else {dg.leave();return}
                    let tempCellShadow = Cell(icon: shadowImage, rate: Int(pow(Double(2), Double(x))), cost: Int(pow(Double(x),Double(x))) )
                    shadowHolding.append(tempCellShadow)
                    tempHolding.append(tempCell)
                    finalHolding = tempHolding.sorted(by: { $0.rate < $1.rate })
                    finalShadow = shadowHolding.sorted(by: { $0.rate < $1.rate })
                    dg.leave()
                })
            }
        }
        dg.notify(queue: .main) {
            self.cells.append(contentsOf: tempCellHolding)
            self.tableView.append(contentsOf: finalShadow)
            self.tableViewShadow.append(contentsOf: finalShadow)
            self.tableViewLight.append(contentsOf: finalHolding)
        }
    }
    
    // Source Of Truth
    var cells: [Cell] = [] {
        didSet {
            NotificationCenter.default.post(notification)
        }
    }
    
    var tableView: [Cell] = [] {
        didSet {
            NotificationCenter.default.post(notification)
        }
    }
    
    var tableViewShadow: [Cell] = [] {
        didSet {
            NotificationCenter.default.post(notification)
        }
    }
    
    var tableViewLight: [Cell] = [] {
        didSet {
            NotificationCenter.default.post(notification)
        }
    }
    
    // CRUD Functions
    func fetchSearchData (indexNumber: Int, completion: @escaping (SearchData?) -> Void) {
        var searchTerm: String
        // Base URL
        guard let baseURL = URL(string: "https://pixabay.com/api/") else {completion(nil); return}
        // Add Key
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let APIKeyQueryItem = URLQueryItem(name: "key", value: "12884186-a3bc29b440f4c9456ce2bea39")
        switch indexNumber {
        case 0:
            let rand = Int.random(in: 0...1)
            if rand == 0 {
                searchTerm = "Shrub"
            } else {
                searchTerm = "Boulder"
            }
        case 1:
            searchTerm = "Grassland"
        case 2:
            searchTerm = "Forest"
        case 3:
            searchTerm = "Mountain"
        case 4:
            searchTerm = "Farm"
        case 5:
            searchTerm = "House"
        case 6:
            searchTerm = "Mansion"
        case 7:
            searchTerm = "Factory"
        case 8:
            searchTerm = "Oilrig"
        case 9:
            searchTerm = "Skyscraper"
        case 10:
            searchTerm = "Monument"
        case 11:
            searchTerm = "Space+Station"
        case 12:
            searchTerm = "Planet"
        case 13:
            searchTerm = "Solar+System"
        case 14:
            searchTerm = "Galaxy"
        case 15:
            searchTerm = "Universe"
        default:
            completion(nil); return
        }
        let imageQuery = URLQueryItem(name: "q", value: searchTerm)
        let imageType = URLQueryItem(name: "image_type", value: "vector")
        components?.queryItems = [APIKeyQueryItem, imageQuery, imageType]
        guard let finalURL = components?.url else {completion(nil); return}
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(SearchData.self, from: data)
                    completion(decodedData); return
                } catch {
                    print(error.localizedDescription)
                    self.fetchSearchData(indexNumber: indexNumber, completion: completion)
                    return
                }
            }
        }.resume()
    }
    
    func fetchCell (indexNumber: Int, searchData: SearchData, completion: @escaping (Cell?) -> Void) {
        var rate: Int
        if indexNumber == 0{
            rate = 1
        } else {
            rate = Int(pow(Double(2), Double(indexNumber)))
        }
        let randomNumber = Int.random(in: 0...searchData.hits.count - 1)
        let hit = searchData.hits[randomNumber]
        let url = hit.largeImageURL
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                guard let icon = UIImage(data: data) else {completion(nil); return}
                let cell = Cell(icon: icon, rate: rate)
                completion(cell); return
            }
            }.resume()
    }
    
    // Check if two cells are equal - This is equatable, but it wasn't calling before for some reason.
    func sameCell (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.cost == rhs.cost && lhs.icon == rhs.icon && lhs.rate == rhs.rate
    }
}
