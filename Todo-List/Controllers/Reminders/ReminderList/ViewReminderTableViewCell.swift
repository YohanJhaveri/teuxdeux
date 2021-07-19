//
//  ViewReminderTableViewCell.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import UIKit

class ViewReminderTableViewCell: UITableViewCell {
    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var reminderDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
