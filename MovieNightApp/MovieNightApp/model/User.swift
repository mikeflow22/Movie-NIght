//
//  User.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class User {
    var didPickMovie: Bool = false
    var selectedMovie: Movie?
    var identifier = UUID().uuidString
    
     init(selectedMovie: Movie?){
        self.selectedMovie = selectedMovie
    }
}
