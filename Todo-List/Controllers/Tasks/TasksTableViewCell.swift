//
//  TableViewCell.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit
import Firebase

class TasksTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkboxImage: UIImageView!
    
    var taskID: String = ""
    
    let firestore = Firestore.firestore()
    
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
        checkboxImage.image = Icons.checkmarkCircle
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.firestore
                .collection("tasks")
                .document(self.taskID)
                .updateData([ "done": true ]) { error in
                    if error != nil {
                        print("Could not complete task")
                        return
                    }
                    
                    self.checkboxImage.image = Icons.circle
                }
        }
    }
}
