//
//  AddReminderTableViewCell.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import UIKit

class AddReminderTableViewCell: UITableViewCell {

    var delegate: AddReminderTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAddReminderPressed(_ sender: UIButton) {
       if self.delegate != nil { //Just to be safe.
//         self.delegate.performSegueFromCell()
       }
    }
}

protocol AddReminderTableViewCellDelegate {
    func triggerActionSheet()
}
