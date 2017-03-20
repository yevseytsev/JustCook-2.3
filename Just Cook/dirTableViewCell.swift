//
//  dirTableViewCell.swift
//  Just Cook
//
//  Created by Excellence on 11/17/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class dirTableViewCell: UITableViewCell {

    @IBOutlet weak var direction_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
