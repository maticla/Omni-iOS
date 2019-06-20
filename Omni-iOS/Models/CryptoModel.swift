//
//  CryptoModel.swift
//  Omni-iOS
//
//  Created by Matic on 19/06/2019.
//  Copyright © 2019 Matic. All rights reserved.
//

import Foundation

typealias CryptoData = [CryptoModel]

struct CryptoModel: Decodable {
    let id, symbol, name: String
    let image: String
    var current_price: Double
}
