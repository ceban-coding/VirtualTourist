//
//  FlickrPhoto.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/21/21.
//

import Foundation

struct JsonFlickrApi: Codable {
    let photos: FlickrPhotoResponse
}

struct FlickrPhotoResponse: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
}
