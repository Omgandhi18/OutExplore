//
//  MapViewController.swift
//  OutExplore
//
//  Created by Om Gandhi on 26/01/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        fetchPointsOfInterest(at: mapView.region.center)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "POIAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    func fetchPointsOfInterest(at coordinate: CLLocationCoordinate2D) {
          let filter = MKPointOfInterestFilter(including: [.amusementPark,.aquarium,.beach,.campground,.marina,.nationalPark,.park,.stadium,.winery,.zoo])
           let request = MKLocalSearch.Request()
            request.pointOfInterestFilter = filter
           request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

           let search = MKLocalSearch(request: request)
           search.start { [weak self] (response, error) in
               guard let self = self, error == nil else {
                   print("Error searching for points of interest: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               // Add annotations for each point of interest
               if let items = response?.mapItems {
                   for item in items {
                       let annotation = MKPointAnnotation()
                       annotation.coordinate = item.placemark.coordinate
                       annotation.title = item.name
                       self.mapView.addAnnotation(annotation)
                   }
               }
           }
       }
}
