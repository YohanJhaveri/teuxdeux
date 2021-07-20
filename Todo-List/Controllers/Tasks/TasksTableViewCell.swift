//
//  TableViewCell.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkboxImage: UIImageView!
    
    var task: Task?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = .gray
        } else {
            contentView.backgroundColor = CustomColors.background
        }
    }
    
    @IBAction func onCheckPressed(_ sender: UIButton) {
        TaskHandler.completeTask(task: self.task!)
    }
}
