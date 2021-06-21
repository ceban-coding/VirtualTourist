//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/7/21.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
  
    //MARK: - Outlets 
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    var dataController: DataController!
    var annotations = [Pin]()
    let manager = CLLocationManager()
    
    //MARK: - LifeCycle Functions
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let longPressGestureRecogn = UILongPressGestureRecognizer(target: self, action: #selector(addAnotation(_ :)))
        longPressGestureRecogn.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGestureRecogn)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
   
   

    //MARK: - Action Buttons
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    
   //MARK: - Add pin annotation
    
    @objc func addAnotation(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == UIGestureRecognizer.State.began else { return }
        let location = sender.location(in: mapView)
        let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = myCoordinate
        mapView.addAnnotation(myPin)
        let pin = Pin(context: DataController.shared.viewContext)
        pin.lat = Double(myCoordinate.latitude)
        pin.long = Double(myCoordinate.longitude)
        annotations.append(pin)
        DataController.shared.save()
    }
    
    
    //MARK: - add user location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    

}
