//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/21/21.
//

import Foundation

class FlickrClient {
    
    //Shared Instacnce
    static let shared = FlickrClient()
    
    let apiKey = "e8393a06051e09568947d201f2bed3b8"
    let secret = "122073b6f64993cb"
    
    var flickrBase = "https://api.flickr.com/services/rest/"
    var flickrSearch = "flickr.photos.search"
    
    var flickrObjects: [FlickrPhoto] = []
    
    func getFlickrPhotos(lat: Double, lon: Double, page: Int, completion: @escaping ([FlickrPhoto]?, Error?) -> Void) {
        
        guard var components = URLComponents(string: flickrBase) else {
            completion(nil, NetworkErrors.invalidComponents)
            return }
        
        
        let queryItem1 = URLQueryItem(name: "api_key", value: apiKey)
        let queryItem2 = URLQueryItem(name: "method", value: flickrSearch)
        let queryItem3 = URLQueryItem(name: "format", value: "json")
        let queryItem4 = URLQueryItem(name: "lat", value: String(lat))
        let queryItem5 = URLQueryItem(name: "lon", value: String(lon))
        let queryItem6 = URLQueryItem(name: "radius",  value: "10")
        let queryItem7 = URLQueryItem(name: "nojsoncallback", value: "1")
        let queryItem8 = URLQueryItem(name: "page", value: String(page))
        components.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4, queryItem5, queryItem6, queryItem7, queryItem8]
        
        guard let url = components.url else {
            completion(nil, NetworkErrors.invalidURL)
        return }
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completion(nil, NetworkErrors.httpError)
                return }
            
            guard let data = data else {
                completion(nil, NetworkErrors.nilData)
                return }
            
            
            let decoder = JSONDecoder()
            
            do {
                let photoData = try decoder.decode(JsonFlickr.self, from: data)
                print(photoData)
                
                let photos = Array(photoData.photos.photo.prefix(100))
                completion(photos, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
