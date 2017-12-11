//
//  UserCollectionViewCell.swift
//  Glimpse
//
//  Created by Nitin on 10/13/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageViewProfile:UIImageView!
     @IBOutlet var imgPlus:UIImageView!
    @IBOutlet var imgBorder:UIImageView!
    @IBOutlet var labelNo:UILabel!
    @IBOutlet var labelName:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
