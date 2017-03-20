//
//  MealTableViewCell.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-3.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
    func setInternalField(recipe: Recipe)
    {
        contentView.backgroundColor = UIColor.clear
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor.clear
        backgroundView = backView
        
        nameLabel.text = recipe.name
        typeLabel.text = recipe.type
        timeLabel.text = recipe.time
        
        switch recipe.difficulty!.intValue {
        case 1:
             difficultyLabel.text = NSLocalizedString("Easy", comment: "-")
        case 2:
            difficultyLabel.text = NSLocalizedString("Medium", comment: "-")
        case 3:
            difficultyLabel.text = NSLocalizedString("Hard", comment: "-")
        default:
            difficultyLabel.text = NSLocalizedString("Easy", comment: "-")
        }
        
        let sorter = NSSortDescriptor(key: "index", ascending: true)
        
        
        photoImage.image = UIImage(named: "placeholder.png")
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = 15
        
        if let photoCollection = recipe.photos?.sortedArray(using: [sorter]) {
            guard photoCollection.count > 0 else {
                return
            }
            let firstPhotoEntity = photoCollection.first as! Photo
            photoImage.image = UIImage(data: firstPhotoEntity.photo!)
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
