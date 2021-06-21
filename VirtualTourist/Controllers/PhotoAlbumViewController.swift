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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    

    
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // The persistent container is available.
        
    }
    

    //MARK: - Action Buttons
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
    }
    
    
    
}
