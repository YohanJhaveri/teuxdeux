//
//  SettingsViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

struct SettingsOption {
    let title: String
    let image: UIImage
    let color: UIColor
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var optionsList: UITableView!
    
    let options = [
        SettingsOption(title: "Date", image: UIImage(systemName: "calendar")!, color: UIColor.systemRed),
        SettingsOption(title: "Time", image: UIImage(systemName: "clock")!, color: UIColor.systemBlue),
        SettingsOption(title: "Flag", image: UIImage(systemName: "flag")!, color: UIColor.systemYellow)
    ]
    
    let reminders = [
        1,
        2,
        3,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsList.delegate = self
        optionsList.dataSource = self
        optionsList.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Deadline", "Reminders"][section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [options.count, reminders.count][section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsList.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        let option = options[indexPath.row]
        cell.imageIconView.image = option.image
        cell.imageContainerView.backgroundColor = option.color
        cell.imageIconView.tintColor = .white
        cell.imageIconView.tintColor = .white
        cell.titleLabel.text = option.title
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}
