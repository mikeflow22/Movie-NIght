//
//  NetworkManager.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
enum GenreIds: Int {
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
}
class NetworkManager {
    private let apiKey = "3021207a0f44385e84ef7cc905fb9320"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    
    func fetchMoviesBy( genre: inout String, completion: @escaping([Movie]?, Error?) -> Void){
        let baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //set the query items
        switch genre {
        case "Action":
            genre = "\(GenreIds.Action.rawValue)"
            case "Adventure":
            genre = "\(GenreIds.Adventure.rawValue)"
            case "Animation":
            genre = "\(GenreIds.Animation.rawValue)"
        default:
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
        }
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "with_genres", value: genre)]
        guard let finalURL = urlComponents?.url else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
               completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, NSError())
                return
            }
            
            do {
                let moviesFromGenre = try JSONDecoder.snakecaseDecoder.decode(MovieDictionary.self, from: data).results
                completion(moviesFromGenre, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
        
    }
}
