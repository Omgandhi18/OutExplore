//
//  ViewController.swift
//  OutExplore
//
//  Created by Om Gandhi on 26/01/24.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    
    var globalLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Initialize CLLocationManager
                locationManager = CLLocationManager()
                locationManager.delegate = self

                // Check for location services authorization
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkLocationAuthorization()
            } else {
                // Handle the case where location services are not enabled
                print("Location services are not enabled")
            }
        }
                
    }

    @IBAction func btnOpenMap(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewStory") as! MapViewController
        mapVC.location = globalLocation
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // You have permission to access the location when the app is in use
                startUpdatingLocation()
            case .denied:
                // The user has denied location access
                // You can show an alert or guide the user to settings to enable location
                print("Location access denied. Please enable it in Settings.")
            case .notDetermined:
                // Request location access
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // The user has restricted location access
                // You may want to handle this case based on your app's requirements
                print("Location access is restricted.")
            case .authorizedAlways:
                // You have permission to access the location always
                // Handle accordingly based on your app's requirements
                break
            @unknown default:
                break
            }
        }

        func startUpdatingLocation() {
            // Start updating the location
            locationManager.startUpdatingLocation()

            // Additional configuration for location manager, if needed
            // locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // locationManager.distanceFilter = 10 // in meters
        }

        // MARK: - CLLocationManagerDelegate

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // Handle location updates
            if let location = locations.first {
                // Use the location data as needed
                globalLocation = location
                print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // Handle location manager errors
            print("Location manager error: \(error.localizedDescription)")
        }
    
}

