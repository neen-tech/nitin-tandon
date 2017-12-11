//
//  GlobalTableViewCell.swift
//  Glimpse
//
//  Created by Nitin on 10/9/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class GlobalTableViewCell: UITableViewCell {
    
    //GENDER CELL OBEJECTS
    
    @IBOutlet var labelGender:UILabel!
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var txt : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
