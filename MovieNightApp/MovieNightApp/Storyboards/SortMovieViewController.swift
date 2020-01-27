//
//  SortMovieViewController.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class SortMovieViewController: UIViewController {
    
    var network: NetworkManager? {
        didSet {
            print("network did hit")
        }
    }
    var movies: [Movie]? {
        didSet {
            print("movies did hit")
            if let movies = movies {
                DispatchQueue.main.async {
                    self.movies = self.populateTableViews(movies: movies)
                    self.myTableView.reloadData()
                }
            }
        }
    }
    var selectedIds: [Int] = []
    var id: Int? {
        didSet {
            if let id = id,
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ids in viewdid load: \(selectedIds)")
        
        let network = network {
            print("id did hit")
            network.fetchMoviesBy(genres: selectedIds) { (movies, error) in
                if let error = error {
                    print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                    return
                }
                if let movies = movies {
                    self.movies = movies
                } else {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                }
            }
        } else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            
        }
    }
    
    func populateTableViews(movies: [Movie]) -> [Movie]{
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard let movies = network?.sortMoviesByRatings(movies) else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return []
            }
            return movies
        case 1:
            guard let movies = network?.sortMoviesByRatings(movies) else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return []
            }
            return movies
        case 2:
            guard let movies = network?.sortMoviesByRatings(movies) else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return []
            }
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
        
        let movie = movies?[indexPath.row]
        cell.textLabel?.text = movie?.title
        return  cell
    }
    
    
}
