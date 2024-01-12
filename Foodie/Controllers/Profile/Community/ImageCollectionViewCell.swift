//
//  ImageCollectionViewCell.swift
//  Foodie
//
//  Created by Mac on 08/01/2024.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
 
    
    func configure(image: UIImage){
        
        self.imageView.layer.cornerRadius = 20
        self.imageView.layer.masksToBounds = true
             
        self.imageView.image = image
        
    }

    
   
     
 
}
