//
//  TaskFormViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/7/21.
//

import UIKit
import Firebase

class TaskFormViewController: UIViewController {
    @IBOutlet weak var taskNameTextField: CustomTextField!
    @IBOutlet weak var taskDateField: UIDatePicker!
    @IBOutlet weak var modalTitle: UILabel!
    
    var selectedTask: Task?
    
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeSelectedTask = selectedTask {
            modalTitle.text = "Edit Task"
            taskNameTextField.text = safeSelectedTask.name
            taskDateField.date = DateHandler.getFirebaseDateValue(from: safeSelectedTask.date) ?? Date()
        }
        
        taskNameTextField.delegate = self
        taskNameTextField.becomeFirstResponder()
        taskNameTextField.autocorrectionType = .no
        taskNameTextField.layer.borderWidth = 0
        UITextField.appearance().tintColor = CustomColors.darkGreen
    }
    
    func showError(message: String) {
        taskNameTextField.addPlaceholder(text: message, color: CustomColors.error!)
    }
    
    func handleCallback(error: Error?) {
        if error != nil {
            self.showError(message: error!.localizedDescription)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSubmit() {
        let name = taskNameTextField.text
        let email = auth.currentUser?.email
        
        if name == nil {
            showError(message: "Task cannot be empty")
            return
        }
        
        if email == nil {
            showError(message: "User is not signed in")
            return
        }
        
        let date = DateHandler.getFirebaseDateString(from: taskDateField.date)
        
        if let selectedTask = selectedTask {
            TaskHandler.updateTask(id: selectedTask.id, updatedFields: [
                "name": name!,
                "date": date
            ], completion: handleCallback)
        } else {
            TaskHandler.createTask(createdFields: [
                "user": email!,
                "name": name!,
                "date": date,
                "done": false
            ], completion: handleCallback)
        }
    }
    
    
    @IBAction func onSubmitPress(_ sender: UIButton) {
        handleSubmit()
    }
    
    
    @IBAction func onCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSubmit()
        return true
    }
}
