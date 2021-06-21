//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/7/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var currentLatitude: Double?
    var currentLongitude: Double?
 
    
    //MARK: - Set up Collcetion View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrViewCell", for: indexPath) as! FlickrViewCell
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setCenter()
                
    }
    

    //MARK: - Action Buttons
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
    }
    
    
    
}

//MARK: - Set up MapView Delegate

extension PhotoAlbumViewController: MKMapViewDelegate {
    
    func setCenter() {
        if let latitude = currentLatitude,
            let longitude = currentLongitude {
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.setCenter(center, animated: true)
            let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
            mapView.setRegion(myRegion, animated: true)
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = center
            mapView.addAnnotation(annotation)
        }
    }
}
