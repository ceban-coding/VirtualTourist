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

class PhotoAlbumViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollectionViewBtn: UIButton!
    
    //MARK: - Properties
    
    var currentLatitude: Double?
    var currentLongitude: Double?
    var pin: Pin!
    var flickrPhotos: [FlickrPhoto] = []
    let numbersOfColumns: CGFloat = 3
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var savedPhotoObjects = [Photo]()
    
    
    
    //MARK: - LifeCycle Fuctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        setCenter()
        getFlickrPhoto()
        activityIndicator.startAnimating()
        setupBarButtonItems()
        loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Fetch Core Data
    fileprivate func loadSavedData() {
        if fetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                        
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error performing fetch")
        }
    }
  
    
    //MARK: - Methods
    
    
    // Make a call to FlikrClient
    func getFlickrPhoto() {
        FlickrClient.shared.getFlickrPhotos(lat: currentLatitude!, lon: currentLongitude!, page: 1, completion: { (photos, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlertMessage()
                    print(error.localizedDescription)
                }
            } else {
                if let photos = photos {
                    self.flickrPhotos = photos
                    self.savePhotoToCoreData(photos: photos)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
    }
    
    // Alert  message method
    func showAlertMessage() {
        let alertVc = UIAlertController(title: "Error", message: "Error retrieving data", preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVc, animated: true)
    }
    
    
    // Save photos to coreData
    func savePhotoToCoreData(photos: [FlickrPhoto]) {
        
        for flickrPhoto in photos {
            let photo = Photo(context: DataController.shared.viewContext)
            if let url = URL(string: flickrPhoto.imageURLString()) {
              photo.imageData = try? Data(contentsOf: url)
            }
            photo.imageURL = flickrPhoto.imageURLString()
            photo.pin = pin
            savedPhotoObjects.append(photo)
            DataController.shared.save()
        }
    }
    
    //MARK: - UICollectionView: Select Multiple items & delete UICollectionViewCell
    
    
    // Define enum points
    enum Mode {
        case view
        case select
    }
    
    
    // Dictionare for store status of indexPath
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    
    //Switch selected button on selection
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case.view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                dictionarySelectedIndexPath.removeAll()
                
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
            case.select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    // Create UIBarButtons
    
    //Created select buttonItem
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    //Created delete buttonItem
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeletButtonClicked(_:)))
        return barButtonItem
    }()
    
    
    // Methods select & delete button clicked
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mMode =  mMode == .view ? .select : .view
    }
    
    @objc func didDeletButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        
    collectionView.deleteItems(at: deleteNeededIndexPaths)
       dictionarySelectedIndexPath.removeAll()
        
    }
    
    // Setup bar buttonItem method
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
        
    }

    //MARK: - Action Buttons
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        collectionView.reloadData()
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


//MARK: - Set up Collcetion View Delegates

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        default:
            return flickrPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrViewCell", for: indexPath) as! FlickrViewCell
        
        switch indexPath.section {
        case 0:
            let photoObject = fetchedResultsController.object(at: indexPath)
            DispatchQueue.main.async {
                let image = UIImage(data: photoObject.imageData! as Data)
                cell.photoImage.image = image
            }
        default:
            let shuffledFlickrPhotos = flickrPhotos.shuffled()
            if let url = URL(string: shuffledFlickrPhotos[indexPath.row].imageURLString()) {
                cell.setupCell(url: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / numbersOfColumns
        return CGSize(width: width, height: width)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
       }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
          collectionView.deselectItem(at: indexPath, animated: true)
            _ = collectionView.cellForItem(at: indexPath)
        case .select:
          dictionarySelectedIndexPath[indexPath] = true
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
          dictionarySelectedIndexPath[indexPath] = false
        }
       
    }
    
}



