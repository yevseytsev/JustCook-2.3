//
//  DetailedTableViewCell.swift
//  Just Cook
//
//  Created by Excellence on 11/21/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class DetailedTableViewCell: UITableViewCell {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var ingName: UILabel!
    @IBOutlet weak var ingQty: UILabel!
    
    func hideImageView(_ flag: Bool) {
        imageView?.isHidden = flag
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = contentView.frame
        frame.origin.x = 8
        frame.origin.y = 8
        frame.size.width = UIScreen.main.bounds.width - 16
        frame.size.height = frame.size.width
        
        imageView?.frame = frame
        imageView?.layer.masksToBounds = true
        ((imageView?.layer.cornerRadius = 15) != nil)
    }
    
    func addPhoto(_ image: UIImage) {
        hideImageView(false)
    
        imageView?.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
