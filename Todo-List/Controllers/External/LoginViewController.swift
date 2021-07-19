//
//  LoginViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var submitButton: CustomButton!
    
    var email: InputGroup {
        return InputGroup(
            field: emailTextField,
            error: emailErrorLabel
        )
    }
    
    var password: InputGroup {
        return InputGroup(
            field: passwordTextField,
            error: passwordErrorLabel
        )
    }
    
    var inputs: [String: InputGroup] {
        return [
            "email": email,
            "password": password,
        ]
    }
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.field.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        password.field.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        email.field.delegate = self
        password.field.delegate = self
    }
    
    func handleLogin() {
        let emailText = email.field.text!
        let passwordText = password.field.text!
        
        clearErrors()
    
        AuthHandler.handleAuth(from: .login, email: emailText, password: passwordText) { [weak self] errors in
            if !errors.isEmpty {
                self?.showErrors(errors: errors)
                return
            }

            self?.performSegue(withIdentifier: Segues.loginToList, sender: self)
        }
    }
    
    func showError(input: InputGroup, message: String) {
        input.field.backgroundColor = CustomColors.inputError
        input.error.text = message
    }
    
    func showErrors(errors: [String: String]) {
        for (name, message) in errors {
            showError(input: inputs[name]!, message: message)
        }
    }
    
    func clearError(input: InputGroup) {
        input.field.backgroundColor = CustomColors.lightGreen
        input.error.text = ""
    }
    
    func clearErrors() {
        clearError(input: email)
        clearError(input: password)
    }
    
    @IBAction func onSubmitPressed(_ sender: Any) {
        handleLogin()
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email.field {
            self.password.field.becomeFirstResponder()
        } else {
            handleLogin()
        }
        
        textField.resignFirstResponder()  //if desired
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == email.field {
            clearError(input: email)
        } else {
            clearError(input: password)
        }
    }
}
