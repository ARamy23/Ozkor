//
//  MenuTableViewCell.swift
//  Ozkor
//
//  Created by Ahmed Ramy on 4/8/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import UIKit



class MenuTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setModel(model: MenuItemModel)
    {
        menuImageView.image = UIImage(named: model.imageViewString)
        contentView.backgroundColor = model.cellBackgroundColor
    }
}
