//
//  YourGlimpseTableViewCell.swift
//  Glimpse
//
//  Created by Rameshwar on 11/8/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class YourGlimpseTableViewCell: UITableViewCell {

    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblLikes : UIButton!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var lblTotalComments : UILabel!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnComment : UIButton!
    @IBOutlet var lblText : UILabel!
    @IBOutlet var imgPlay : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
