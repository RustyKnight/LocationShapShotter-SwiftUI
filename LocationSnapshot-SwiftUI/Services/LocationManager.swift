//
//  LocationManager.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import Foundation
import MapKit
import Cadmus

private extension CLAuthorizationStatus {
    var isAuthorised: Bool {
        switch self {
        case .notDetermined: return false
        case .restricted: return false
        case .denied: return false
        case .authorizedAlways: return true
        case .authorizedWhenInUse: return true
        @unknown default:
            return false
        }
    }
}

public final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published public var location: CLLocation?
    @Published public var lastError: Error?
    
    public override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus.isAuthorised else { return }
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log(error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        log(debug: "location = \(location)")
        self.location = location
        locationManager.stopUpdatingLocation()
    }
}
