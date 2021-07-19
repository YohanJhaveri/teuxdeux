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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2
    }
}

