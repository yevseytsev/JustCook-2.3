//
//  ingTableViewCell.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Nov-12.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class ingTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
