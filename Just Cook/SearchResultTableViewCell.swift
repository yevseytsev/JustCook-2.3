//
//  SearchResultTableViewCell.swift
//  Just Cook
//
//  Created by lei zhang on 2017-01-02.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var auth: UILabel!
    @IBOutlet weak var type: UILabel!
    
    var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
