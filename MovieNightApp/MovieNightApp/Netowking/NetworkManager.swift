//
//  NetworkManager.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

enum GenreIds: Int {
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
}
class NetworkManager {
    var movies = [Movie]()
    var trendingMovies: [Movie] = []
    
    private let apiKey = "3021207a0f44385e84ef7cc905fb9320"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    
    func fetchMoviesBy( genre: String, completion: @escaping([Movie]?, Error?) -> Void){
        let baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //set the query items
        var genreID = genre
        switch genreID {
        case "Action":
            genreID = "\(GenreIds.Action.rawValue)"
        case "Adventure":
            genreID = "\(GenreIds.Adventure.rawValue)"
        case "Animation":
            genreID = "\(GenreIds.Animation.rawValue)"
        default:
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
        }
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "with_genres", value: genreID)]
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
                self.movies = moviesFromGenre
                completion(moviesFromGenre, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchTrendingMovies(completion: @escaping ([Movie]?, Error?) -> Void){
        let baseURL = URL(string: "https://api.themoviedb.org/3/trending/movie/week")!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let finalURL =  urlComponents?.url else {
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
                let trendingMovies = try JSONDecoder.snakecaseDecoder.decode(MovieDictionary.self, from: data).results
                self.trendingMovies = trendingMovies
                completion(trendingMovies, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchMoviePosterFor(movie: Movie, completion: @escaping (UIImage?, Error?) -> Void){
        let movieURL = URL(string: "http://image.tmdb.org/t/p/w500")!
        let appendingURL  = movieURL.appendingPathComponent(movie.posterPath)
        
        URLSession.shared.dataTask(with: appendingURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
               completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            if let imageFromData = UIImage(data: data) {
                completion(imageFromData, nil)
            }  else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, NSError())
            }
        }.resume()
    }
    
    func sortMoviesByRatings(_ movies: [Movie]){
        let sortedMovies = movies.sorted(by: { $0.voteAverage > $1.voteAverage})
        for movie in sortedMovies {
            print("This movie: \(movie.title) has ratings of: \(movie.voteAverage) stars")
        }
    }
    
    func sortMoviesByPopularity(_ movies: [Movie]){
        let sortedMovies = movies.sorted(by: { $0.popularity > $1.popularity})
        for movie in sortedMovies {
            print("This movie: \(movie.title) popularitys has: \(movie.popularity) votes")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
