//
//  ViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet weak var loginButton: CustomButton!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userHasAccount = userDefaults.value(forKey: Defaults.hasAccount) {
            if userHasAccount as! Bool {
                self.performSegue(withIdentifier: Segues.entryToLogin, sender: self)
            }
        }
    }
}

