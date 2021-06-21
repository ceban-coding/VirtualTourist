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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
  
    //MARK: - Outlets 
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    var dataController: DataController!
    var fetchResultController: NSFetchedResultsController<Pin>!
    var annotations = [Pin]()
    var savedPins = [MKPointAnnotation]()
    let manager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    //MARK: - LifeCycle Functions
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultsController()
        mapView.delegate = self
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
    
    
   //MARK: - FetchRequest
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            annotations = result
            for annotation in annotations {
                let savePin = MKPointAnnotation()
                if let lat = CLLocationDegrees(exactly: annotation.lat), let long = CLLocationDegrees(exactly: annotation.long) {
                    let coordinateLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    savePin.coordinate = coordinateLocation
                    savePin.title = "Photos"
                    savedPins.append(savePin)
                }
            }
            mapView.addAnnotations(savedPins)
        }
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
        myPin.title = "Photos"
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
    
    //MARK: - Map view functions
    
    //Push to PhotoViewControler from annotation
   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let vc = storyboard?.instantiateViewController(identifier: "photoAlbumViewController") as! PhotoAlbumViewController
    let locationLat = view.annotation?.coordinate.latitude
    let locationLon = view.annotation?.coordinate.longitude
    let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationLat!, longitude: locationLon!)
    let selectedPin: MKPointAnnotation = MKPointAnnotation()
    selectedPin.coordinate = myCoordinate
    vc.currentLatitude = myCoordinate.latitude
    vc.currentLongitude = myCoordinate.longitude
    navigationController?.pushViewController(vc, animated: true)
    }

    //Returns the View associated with the specified annotation object
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifer = "annotation"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifer) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifer)
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        } else {
            view!.annotation = annotation
        }
        return view
    }
    
}
