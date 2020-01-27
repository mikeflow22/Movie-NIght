//
//  NetworkManager.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
class NetworkManager {
    var movies = [Movie]()
    var trendingMovies: [Movie] = []
    var genres = [Genre]()
    
    private let apiKey = "3021207a0f44385e84ef7cc905fb9320"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    
    func fetchMoviesBy( genres: [Int], completion: @escaping([Movie]?, Error?) -> Void){
        let baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //turn the array of ints into strings so we can create a query item of it
        let genreStrings = genres.compactMap { String($0) }
        //now separate the array of int strings by a comma
        let joinedGenreStrings = genreStrings.joined()
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "with_genres", value: joinedGenreStrings)]
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
    
    func fetchGenres(completion: @escaping ([Genre]?, Error?) -> Void){
        let baseURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list")!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
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
                let genres = try JSONDecoder.snakecaseDecoder.decode(GenreDictionary.self, from: data).genres
                self.genres = genres
                
                completion(genres, nil)
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
    
    func sortMoviesByRatings(_ movies: [Movie]) -> [Movie]{
        return  movies.sorted(by: { $0.voteAverage > $1.voteAverage})
    }
    
    func sortMoviesByPopularity(_ movies: [Movie]) -> [Movie] {
        return movies.sorted(by: { $0.popularity > $1.popularity})
    }
    
    func sortMoviesByReleaseDate(_ movies: [Movie]) -> [Movie] {
//        return movies.sorted(by: { $0.date! > $1.date! })
        let sortedMoviesByDate  = movies.sorted(by: { if let movieDate1  = $0.date, let movieDate2 = $1.date {
            return movieDate1 > movieDate2
            }
            return true
        })
        return sortedMoviesByDate
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
