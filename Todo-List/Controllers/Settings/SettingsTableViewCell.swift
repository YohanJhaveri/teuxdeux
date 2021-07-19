//
//  SettingsTableViewCell.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageIconView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
