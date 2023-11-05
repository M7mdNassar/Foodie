//
//  HomeTableViewCell.swift
//  Foodie
//
//  Created by Mac on 05/11/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    @IBAction func displayButton(_ sender: UIButton) {
        print("Button Clicked")
    }
    
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        print("Button Clicked")
    }
    
    
    
    func setUpCell(img: UIImage , name: String ){
        imgRestaurant.image = img
        labelRestaurantName.text = name
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
