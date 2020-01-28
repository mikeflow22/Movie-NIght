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
        
        //fetch genres to populate tableView
        network.fetchGenres { (genres, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
            guard let returnedGenres = genres else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            //assign the returned Genres to our stored property
            self.genres = returnedGenres
            print("***********************Returned Genres: \(returnedGenres.count)")
            
//            for genre in returnedGenres {
//                print("Genre: \(genre.name) id = \(genre.id)")
//            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genres?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! GenreTableViewCell
        if let genre = genres?[indexPath.row] {
            cell.genreNameLabel.text = genre.name
            
            //add a check mark
            if selectedGenres.contains(genre) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //get the genre that was selected
        guard let genre = genres?[indexPath.row] else { return }
        selectedGenres.insert(genre)
        
//        if selectedGenres.contains(genre) {
//            //if genre is already in the set - remove it
//            selectedGenres.remove(genre)
//        } else {
//            //if not, then insert it into the set
//            selectedGenres.insert(genre)
//        }
        
        //reload tableView
        tableView.reloadData()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        //check to see if selectedGenres has value, that it is not empty
        guard !selectedGenres.isEmpty else {
            //present alert
            return
        }
        
        //pass the selectedGenres to the delegate - mainViewController -notify the delegate that genres were selected
        self.delegate?.searchMovieViewController(self, didSelectGenres: self.selectedGenres)
        dismiss(animated: true)
    }
}

