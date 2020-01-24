//
//  URLConstructor.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

protocol URLConstructor: Codable {
    static var path: String { get }
}
