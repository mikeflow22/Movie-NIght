//
//  User.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class User {
    var didPickGenre: Bool = false
    var selectedGenres: Set<Genre>?
    
    init(selectedGenres: Set<Genre>?){
        self.selectedGenres = selectedGenres
    }
}
