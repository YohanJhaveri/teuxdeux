//
//  LocationReminderFormViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/13/21.
//

import UIKit

class LocationReminderFormViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var locationSearch: UISearchBar!
    @IBOutlet weak var locationResults: UITableView!

    var selectedTask: Task?
    var selectedReminder: LocationReminder?
    var places: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearch.text = selectedReminder?.location.address
        locationSearch.becomeFirstResponder()
        locationSearch.delegate = self
        locationResults.delegate = self
        locationResults.dataSource = self
        locationResults.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension LocationReminderFormViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = locationSearch.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            GooglePlacesHandler.shared.findPlaces(query: searchText) { result in
                switch result {
                case .success(let places):
                    self.places = places
                    
                    DispatchQueue.main.async {
                        self.locationResults.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func onCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationReminderFormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationResults.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationResults.deselectRow(at: indexPath, animated: true)
        
        let address = places[indexPath.row]
                
        GooglePlacesHandler.shared.geocode(for: address) { coordinates, error in
            let latitude = coordinates.latitude
            let longitude = coordinates.longitude

            var reminder: LocationReminder

            if let selectedReminder = self.selectedReminder {
                reminder = LocationReminder(
                    id: selectedReminder.id,
                    taskID: selectedReminder.taskID,
                    createdAt: selectedReminder.createdAt,
                    location: Location(address: address, latitude: latitude, longitude: longitude)
                )
            } else {
                reminder = LocationReminder(
                    id: UUID().uuidString,
                    taskID: self.selectedTask?.id ?? "",
                    createdAt: Date().timeIntervalSince1970,
                    location: Location(address: address, latitude: latitude, longitude: longitude)
                )
            }

            ReminderHandler.writeReminder(reminder: reminder, task: self.selectedTask!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
