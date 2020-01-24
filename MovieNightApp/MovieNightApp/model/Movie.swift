//
//  Movie.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/23/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class Movie: Codable {
    private let apiKey = "3021207a0f44385e84ef7cc905fb9320"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
}
