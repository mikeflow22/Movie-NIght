//
//  TopLevelDictionary.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
struct TopLevelDictionary<T: URLConstructor>: Codable {
    let results: [T]
}
