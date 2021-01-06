//
//  CluesTableViewCell.swift
//  Jeopardy
//
//  Created by Christian Shirichena on 1/2/21.
//

import UIKit

class CluesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTopLabel: UILabel!
    @IBOutlet weak var cellContentLabel: UILabel!
    
override func awakeFromNib() {
        super.awakeFromNib()
    cellTopLabel.numberOfLines = 1
    cellContentLabel.numberOfLines = 3

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
