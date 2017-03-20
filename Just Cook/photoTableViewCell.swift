//
//  photoTableViewCell.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Nov-12.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class photoTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
