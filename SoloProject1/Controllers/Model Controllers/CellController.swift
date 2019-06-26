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
    
    private init() {
        var tempCellHolding: [Cell] = []
        var tempHolding: [Cell] = []
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
                    let tempCell = Cell(icon: newCell.icon, rate: 2^(x-1) )
                    tempHolding.append(tempCell)
                    dg.leave()
                })
            }
        }
        
        dg.notify(queue: .main) {
            self.cells.append(contentsOf: tempCellHolding)
            self.tableView.append(contentsOf: tempHolding)
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
            searchTerm = "Transparent+Square"
        case 1:
            searchTerm = "House"
        case 2:
            searchTerm = "Farm"
        case 3:
            searchTerm = "Factory"
        case 4:
            searchTerm = "Oilrig"
        case 5:
            completion(nil); return
        case 6:
            completion(nil); return
        case 7:
            completion(nil); return
        case 8:
            completion(nil); return
        case 9:
            completion(nil); return
        case 10:
            completion(nil); return
        case 11:
            completion(nil); return
        case 12:
            completion(nil); return
        case 13:
            completion(nil); return
        case 14:
            completion(nil); return
        case 15:
            completion(nil); return
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
        var rate: Int = 0
        let randomNumber = Int.random(in: 0...searchData.hits.count - 1)
        let hit = searchData.hits[randomNumber]
        let url = hit.largeImageURL
        switch indexNumber {
        case 0:
            rate = 0
        case 1:
            rate = 1
        case 2:
            rate = 2
        case 3:
            rate = 4
        case 4:
            rate = 8
        case 5:
            rate = 16
        case 6:
            rate = 32
        case 7:
            rate = 64
        case 8:
            rate = 128
        case 9:
            rate = 256
        case 10:
            rate = 512
        case 11:
            rate = 1024
        case 12:
            rate = 2048
        case 13:
            rate = 4096
        case 14:
            rate = 8192
        case 15:
            rate = 16384
        default:
            completion(nil); return
        }
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
}
