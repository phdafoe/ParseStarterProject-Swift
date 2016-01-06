//
//  ICOFeddCustomTableViewCell.swift
//  iCoInstagram
//
//  Created by User on 6/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ICOFeddCustomTableViewCell: UITableViewCell {
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var myCustomImage: UIImageView!
    @IBOutlet weak var myTextLBLNamePicture: UILabel!
    @IBOutlet weak var myTextLBLUserName: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
