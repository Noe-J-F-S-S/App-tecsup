//
//  HomeTableViewCell.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 18/11/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var descriptionPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
