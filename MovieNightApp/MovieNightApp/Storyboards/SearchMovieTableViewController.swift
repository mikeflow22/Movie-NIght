//
//  SearchMovieTableViewController.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
//we need to pass the selected genres back to the main view controller so that we can initialize a user with the genres they selected
protocol SearchMovieDelegate: class {
    func searchMovieViewController(_ searchMovieViewController: SearchMovieTableViewController, didSelectGenres genres: Set<Genre>)
}

class SearchMovieTableViewController: UITableViewController {
    
    let network = NetworkManager()
    var selectedGenres: Set<Genre> = []
    weak var delegate: SearchMovieDelegate?
    
    var genres: [Genre]? {
        didSet {
            print("genres was hit")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        network.fetchMoviesBy(genre: "Adventure") { (movies, error) in
        //            guard let returnedMovies = movies else {
        //                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
        //                return
        //            }
        //            for movie in returnedMovies {
        //                print("This is the movie's name: \(movie.title) and the genre: \(movie.genreIds)")
        //            }
        //            print("**************************************************************************************")
        //            network.sortMoviesByRatings(returnedMovies)
        //
        //            print("**************************************************************************************")
        //            network.sortMoviesByPopularity(returnedMovies)
        //        }
        
//        network.fetchTrendingMovies { (movies, error) in
//            if let error = error {
//                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
//                return
//            }
//            guard let returnedMovies = movies else {
//                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                return
//            }
//
//        for movie in returnedMovies {
//            print("This movie: \(movie.title) is trending!")
//            network.fetchMoviePosterFor(movie: movie) { (image, error) in
//                if let error = error {
//                    print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
//                    return
//                }
//                guard let returnedImage = image else {
//                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                    return
//                }
//                print("This is the byte of the image for movie:  \(movie.title) -- bytes: \(returnedImage.pngData()?.count)")
//            }
//        }
//
//        print("**************************************************************************************")
//        network.sortMoviesByRatings(returnedMovies)
//
//        print("**************************************************************************************")
//        network.sortMoviesByPopularity(returnedMovies)
//    }
        
        network.fetchGenres { (genres, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
            guard let returnedGenres = genres else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            self.genres = returnedGenres
            print("*********************** \(returnedGenres.count)")
            
            for genre in returnedGenres {
                print("Genre: \(genre.name) id = \(genre.id)")
            }
        }
        
}

// MARK: - Table view data source

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return genres?.count ?? 0
}


 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! GenreTableViewCell
    let genre = genres?[indexPath.row]
    cell.genreNameLabel.text = genre?.name
    
    //add a check mark
    print("\(genre?.name)")
 // Configure the cell...
 
 return cell
 }
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
    
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSortSegue" {
        guard let destinationVC = segue.destination as? SortMovieViewController else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        guard let index = tableView.indexPathForSelectedRow  else {
                   print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                   return
        }
        
        guard let genres = self.genres else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let id = genres[index.row].id
        destinationVC.id = id
        destinationVC.network = network
    }
 }

}
