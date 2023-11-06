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
    
    
    
    func setUpCell(img: String , name: String , isFavourite: Bool){
        imgRestaurant.image = UIImage(named: img)
        labelRestaurantName.text = name
        favouriteButton.isEnabled = isFavourite
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
