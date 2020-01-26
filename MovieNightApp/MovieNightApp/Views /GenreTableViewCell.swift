//
//  GenreTableViewCell.swift
//  MovieNightApp
//
//  Created by Michael Flowers on 1/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var genreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
    }

}
