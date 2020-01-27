//
//  Movie.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/23/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class Movie: Codable {
    let voteAverage: Double
    let title: String
    let genreIds: [Int]
    let posterPath: String
    let popularity: Double
    let overview: String
    let releaseDate: String
    
    var date: Date? {
        let formatter = DateFormatter()
        return formatter.date(from: releaseDate)
    }
}
