//
//  MainViewModel.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 7/7/21.
//

import Foundation
import SwiftUI
import Combine

class MainViewModel : ObservableObject {
    
    @Published var productStore : ProductStore
    
    // var MainData : ContentData
    // Data must be arragable
    
    init() {
        productStore = ProductStore()
        productStore.sortById()
    }

    func setProductStoreDataFromJson( jsonData : Data? ) {
        if( jsonData != nil ){
            let productListJson = try! JSONDecoder().decode( ProductListJson.self, from: jsonData!)
            productStore = ProductStore(from: productListJson)
        }
    }
    
    func loadImage(){
        
    }
    
    func getDataFromAPI() {
        
    }
    
    func getSetting() {
        
    }
    
    func prepareProductForShow(){
        // Put Id to loadImage
    }
    
    func loadImage( productId : Int) {
        
        guard let coverImageURL = self.productStore.products[productId].coverImageURL else {
            fatalError("Cover ImageURL is not correct!")
        }

        URLSession.shared.dataTask(with: coverImageURL ) { data, resp, err in
            DispatchQueue.main.async {
                self.productStore.products[productId].coverImage = UIImage(data: data!)
                self.productStore.products[productId].coverLoaded = true
                print("Cover id = \(productId) loaded")
            }
        }.resume()
        
        guard let thumbImageURL = self.productStore.products[productId].thumbnailImageURL else {
            fatalError("Thumbnail ImageURL is not correct!")
        }

        URLSession.shared.dataTask(with: thumbImageURL) { data, resp, err in
            DispatchQueue.main.async {
                self.productStore.products[productId].thumbnailImage = UIImage(data: data!)
                self.productStore.products[productId].thumbnailLoaded = true
                print("Thumbnail id = \(productId) loaded")
            }
        }.resume()
    }
    
}


