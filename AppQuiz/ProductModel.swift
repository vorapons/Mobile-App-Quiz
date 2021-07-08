//
//  ProductModel.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 7/7/21.
//

import Foundation
import SwiftUI

struct ProductStore {
    init( from data : ProductListJson ) {
        var products : [Product] = []
        for item in data.list {
            var product = Product()
            product.id = Int(item.id) ?? 0
            product.title = item.title
            product.description = item.description
            product.createdAt = Date() // Comeback to update here
            product.coverImageURL = URL( string: item.image_url.coverURLstring )
            product.thumbnailImageURL = URL( string: item.image_url.thumbURLstring)
            products.append(product)
        }
        self.products = products // do not sort here, sort in ViewModel with setting condition
        scrollPageShow = []
    }
    
    //
    //
    //
    //
    //
    
    init() {
        products = []
        scrollPageShow = []
    }
    
    var products : [Product]
    var scrollPageShow : [Product]
    
    mutating func sortById() {
        self.products.sort{ $0.id > $1.id }
    }
}

struct Product {
    
    var id : Int = 0
    var coverImage : UIImage?
    var thumbnailImage : UIImage?
    var coverImageURL : URL?
    var thumbnailImageURL : URL?
    var coverLoaded : Bool = false
    var thumbnailLoaded : Bool = false
    var title : String = ""
    var description : String = ""
    var createdAt : Date = Date()
    var placeHolder = UIImage(systemName: "icloud.and.arrow.down")
//    var : UIImageView?
    
    var imageLoaded : Bool {
        return coverLoaded && thumbnailLoaded
    }
}

struct ProductListJson : Codable {
    let list : [ProductDataJson]
    let total : Int
}

struct ProductDataJson : Codable {
    var id : String
    var createdAt : String
    var title : String
    var description : String
    var image_url : ImageContent

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case title
        case description
        case image_url
    }
    
//  Example Json Data
//    "id":"1",
//    "createdAt":"2021-06-01T20:31:46.571Z",
//    "title":"Licensed Frozen Chips",
//    "description":"New ABC 13 9370, 13.3, 5th Gen CoreA5-8250U, 8GB RAM, 256GB SSD, power UHD Graphics, OS 10 Home, OS Office A & J 2016",
//    "image_url":{
//    "thumb":"https://picsum.photos/200/200",
//    "cover_image" :"https://picsum.photos/2048"
}

struct ImageContent : Codable {
    
    var thumbURLstring : String
    var coverURLstring : String
    
    enum CodingKeys: String, CodingKey {
        case thumbURLstring = "thumb"
        case coverURLstring = "cover_image"
    }
}

//var productData : ProductList

