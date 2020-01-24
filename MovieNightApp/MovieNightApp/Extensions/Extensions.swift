//
//  Extensions.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var snakecaseDecoder: JSONDecoder {
        let decoder =  JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
