//
//  SortMovieViewController.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class SortMovieViewController: UIViewController {
    
    var network = NetworkManager() {
        didSet {
            print("network did hit")
        }
    }
    var movies: [Movie]? {
        didSet {
            if let movies = movies {
                DispatchQueue.main.async {
                    self.movies = self.populateTableViews(movies: movies)
                    self.myTableView.reloadData()
                }
            }
        }
    }
    var selectedIds: [Int] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ids in viewdid load: \(selectedIds)")
    
            network.fetchMoviesBy(genres: selectedIds) { (movies, error) in
                if let error = error {
                    print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                    return
                }
                if let movies = movies {
                    self.movies = movies
                    print("movies count: \(movies.count)")
                } else {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                }
            }
    }
    
   func populateTableViews(movies: [Movie]) -> [Movie]{
    guard !movies.isEmpty else {  print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
        return []
    }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let movies = network.sortMoviesByRatings(movies)
            return movies
        case 1:
            let movies = network.sortMoviesByReleaseDate(movies)
            return movies
        case 2:
            let movies = network.sortMoviesByPopularity(movies)
            return movies
        default:
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return []
        }
    }
    
}

extension SortMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortMovieCell", for: indexPath)
        guard let movie = movies?[indexPath.row] else { return UITableViewCell() }
          switch segmentedControl.selectedSegmentIndex {
              case 0:
                print("0")
                  cell.textLabel?.text = movie.title
                  cell.detailTextLabel?.text = "Ratings: \(movie.voteAverage)"
              case 1:
                 print("1")
                  cell.textLabel?.text = movie.title
                  cell.detailTextLabel?.text = "Release Date: \(movie.date)"
              case 2:
                 print("2")
                  cell.textLabel?.text = movie.title
                  cell.detailTextLabel?.text = "Popularity: \(movie.popularity)"
              default:
                  print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                  return UITableViewCell()
              }
        
        return  cell
    }
    
    
}
