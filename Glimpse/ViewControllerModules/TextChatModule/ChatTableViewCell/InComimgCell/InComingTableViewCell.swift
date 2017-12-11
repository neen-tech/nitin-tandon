//
//  InComingTableViewCell.swift
//  Glimpse
//
//  Created by Nitin on 11/20/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class InComingTableViewCell: UITableViewCell {
    
    @IBOutlet var imageViewCell :UIImageView!
    @IBOutlet var labelMessage  :UILabel!
    @IBOutlet var labelTime     :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    imageViewCell.roundCorners(corners: .allCorners, radius: imageViewCell.frame.size.height/2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
