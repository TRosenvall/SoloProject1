//
//  SearchData.swift
//  SoloProject1
//
//  Created by Timothy Rosenvall on 6/26/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation

struct SearchData: Decodable {
    
    let totalHits: Int
    let hits: [HitDictionary]
    let total: Int
}

struct HitDictionary: Decodable {
    let largeImageURL: URL

}
