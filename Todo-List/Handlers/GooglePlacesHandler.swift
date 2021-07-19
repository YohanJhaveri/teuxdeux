//
//  GooglePlacesHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/15/21.
//

import Foundation
import GooglePlaces
import Alamofire

enum PlacesError: Error {
    case failedToFind
}


class GooglePlacesHandler {
    static let shared = GooglePlacesHandler()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}

    public func findPlaces(query: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        
        filter.type = .geocode
        
        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil) { results, error in
            if error != nil {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            if let results = results {
                let places: [String] = results.compactMap({ $0.attributedFullText.string })
                completion(.success(places))
            }
        }
    }
    
    func geocode(for address: String, completion: @escaping (CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                    return
                }
            }
                
            completion(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
