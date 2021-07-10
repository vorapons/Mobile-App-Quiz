//
//  ProductModel.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 7/7/21.
//

import Foundation
import SwiftUI

enum SortOption {
    case AZasc
    case AZdesc
    case CreateAtAsc
    case CreateAtDesc
    case IDAsc
    case IDDecs
}

func isoStringDateToDate( string : String) -> Date {
    let desDateFormatter = DateFormatter()
    desDateFormatter.timeZone  = TimeZone.current
    desDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    if let raw = desDateFormatter.date(from:string){
        return raw
    }
    else {
        return Date()
    }
}

struct ProductStore {
    
    var sortOption : SortOption {
        get {
           return sorting
        }
        set (newSort){
            sorting = newSort
            print("Sorting")
            sortProductsByOption( option : newSort)
        }
    }
    
    private var sorting : SortOption = .CreateAtDesc
    
    init( from data : ProductListJson ) {
        var products : [Product] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "th_TH")
        dateFormatter.dateFormat = "d MMM yy / HH:mm น."
        
        for item in data.list {
            var product = Product()
            product.id = Int(item.id) ?? 0
            product.title = item.title
            product.description = item.description
            product.createdAt = isoStringDateToDate(string: item.createdAt)
            product.createdAtTH = dateFormatter.string(from: product.createdAt)
            product.coverImageURL = URL( string: item.image_url.coverURLstring )
            product.thumbnailImageURL = URL( string: item.image_url.thumbURLstring)
            products.append(product)
        }
        self.products = products // do not sort here, sort in ViewModel with setting condition
    }
    
    init() {
        products = []
    }

    mutating func sortProductsByOption( option : SortOption) {
        
        if( option == .CreateAtAsc ) {
            self.products  = self.products.sorted { $0.createdAt < $1.createdAt }
        }
        else if ( option == .CreateAtDesc ){
            self.products  = self.products.sorted { $0.createdAt > $1.createdAt }
        }
        else if ( option == .AZasc){
            self.products  = self.products.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
        else if ( option == .AZdesc ){
            self.products  = self.products.sorted { $0.title.lowercased() > $1.title.lowercased() }
        }
        else if ( option == .IDAsc ){
            self.products  = self.products.sorted { $0.id < $1.id }
        }
        else if ( option == .IDDecs ){
            self.products  = self.products.sorted { $0.id > $1.id }
        }
        
    }
    
    let numberOfProductInPage = 5
    var products : [Product]
    
    var isProductsEmpty : Bool { products.isEmpty }
    var numOfProducts: Int { products.count }
    var showLists : [[Int]] = [[0,1,2,3,4]]
    var numberOfPages : Int  {
           products.count / numberOfProductInPage
    }
    
    func getProductIDby( index : Int ) -> Int {
        if index < products.count {
            return products[index].id
        }
        else {
            return 0
        }
    }
    
    mutating func updateShowLists(){
        var list : [[Int]] = []
        for i in 0..<numberOfPages {
            var listInPage : [Int] = []
            for j in 0..<5 {
                listInPage.append( (numberOfProductInPage * i) + j)
            }
            list.append(listInPage)
            print("Page \(i) = \(listInPage)")
        }
        self.showLists = list
        print(showLists)
    }
    
    func getIndexIDby( productID : Int ) -> Int? {
        // upgrade here !!
        // aware product id not found : able to check before use this function?
        // should return nil for not found ?
        for i in 0..<products.count {
            if(  products[i].id == productID ) {
                return i
            }
        }
        return nil
    }
    
    mutating func setCoverImageById( ID : Int, image : UIImage) {
        if let index = getIndexIDby(productID: ID) {
            self.products[index].coverImage = image
            self.products[index].coverLoaded = true
        }
    }
    mutating func setThumbImageById( ID : Int, image : UIImage) {
        if let index = getIndexIDby(productID: ID) {
            self.products[index].thumbnailImage = image
            self.products[index].thumbnailLoaded = true
        }
    }
    
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
    var createdAtTH : String = ""
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


