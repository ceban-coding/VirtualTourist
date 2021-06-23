//
//  FlickrViewCell.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/21/21.
//

import UIKit

class FlickrViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var photoImage: UIImageView!
    
    
//    func setImageFrom(url: URL, placeholderImage: UIImage? = nil, completionHandler: @escaping (UIImage?, Error?) -> Void) {
//
//        if let placeholderImage = placeholderImage {
//            photoImage.image = placeholderImage
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                completionHandler(nil, error)
//                return }
//
//            let image = UIImage(data: data)
//            completionHandler(image, nil)
//        }
//        task.resume()
//    }
    
    func setupCell(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.photoImage.image = image
                }
            }
        }
        task.resume()
    }
    
    
//    func handleImageResponse(imageData: FlickrPhoto?, error: Error?) {
//        guard let imageMessage = URL(string: (imageData?.imageURLString())!) else {
//                   print("cannot print URL")
//                   return
//               }
//        setImageFrom(url: imageMessage, placeholderImage: #imageLiteral(resourceName: "film-reel"), completionHandler: handleImageFileResponse(image:error:))
//    }
//    
//    func handleImageFileResponse(image: UIImage?, error: Error?) {
//        DispatchQueue.main.async {
//            if let error = error {
//                print(error)
//            } else {
//                self.photoImage.image = image
//            }
//        }
//    }
  
}
