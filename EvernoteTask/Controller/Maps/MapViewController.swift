////
////  MapViewController.swift
////  EvernoteTask
////
////  Created by Auxenta on 11/28/18.
////  Copyright © 2018 Auxenta. All rights reserved.
////
//
//import UIKit
//import MapKit
//
//class Artwork: NSObject, MKAnnotation {
//    let title: String?
//    let locationAddress: String
//    let discipline: String
//    let coordinate: CLLocationCoordinate2D
//
//    init(title: String, locationAddress: String, discipline: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.locationAddress = locationAddress
//        self.discipline = discipline
//        self.coordinate = coordinate
//        super.init()
//    }
//
//    var subtitle: String? {
//        return locationAddress
//    }
//}
//class MapViewController: UIViewController {
//    var locationDetails : HotelData?
//    let regionRadius: CLLocationDistance = 1000
//    @IBOutlet weak var mapView: MKMapView!
//    override func viewDidLoad() {
//
//        let lat = (locationDetails?.latitude as! NSString).floatValue
//       let long = (locationDetails?.longitude as! NSString).floatValue
//        super.viewDidLoad()
//        self.navigationItem.title = "Map"
//        let initialLocation = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
//         centerMapOnLocation(location: initialLocation)
//        mapView.delegate = self
//        // show artwork on map
//        let artwork = Artwork(title: locationDetails?.title ?? "Destication",
//                              locationAddress: locationDetails?.address ?? "",
//                              discipline: "Sculpture",
//                              coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
//        mapView.addAnnotation(artwork)
//
//    }
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//
//}
//@available(iOS 11.0, *)
//@available(iOS 11.0, *)
//@available(iOS 11.0, *)
//extension MapViewController: MKMapViewDelegate {
//    // 1
//    @available(iOS 11.0, *)
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////        // 2
////        guard let annotation = annotation as? Artwork else { return nil }
////        // 3
////        let identifier = "marker"
////        var view: MKMarkerAnnotationView
////        // 4
////        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
////            as? MKMarkerAnnotationView {
////            dequeuedView.annotation = annotation
////            view = dequeuedView
////        } else {
////            // 5
////            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
////            view.canShowCallout = true
////            view.calloutOffset = CGPoint(x: -5, y: 5)
////            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
////        }
////        return view
////    }
//}
