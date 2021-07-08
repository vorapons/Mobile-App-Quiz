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
    
    func updateShowListOf( page : Int, showIndex : Int ) {
        let numberOfProductsInShowList = productStore.showLists[page].count
        if( page < productStore.showLists.count ) {
            for i in 0..<5 {
                let addIndex = (page * productStore.numberOfProductInPage) + numberOfProductsInShowList + i
                if( addIndex < productStore.products.count ) {
                    productStore.showLists[page].append( addIndex )
                    print("Add to ShowList Index = ",addIndex)
                }
            }
        }
    }
    
    func prepareProductForShow2() -> [Int] {
//        let mainScrollIndex = 0
//        var startIndex = 0
//        var endIndex = 0
//        var productIdList : [Int] = []
//        // check is empty?
//        // check product count?
//        if( mainScrollIndex == 0) {
//            startIndex = 0
//            endIndex = 0 + 5
//            for i in startIndex..<endIndex {
//                if( !productStore.products[i].imageLoaded) {
//                    print("index = \(i)")
//                    productIdList.append(productStore.getProductIDby(index: i))
//                }
//            }
//        }
//        return productIdList
        var productIdList : [Int] = []
        for showList in productStore.showLists {
            for i in showList {
                if( !productStore.products[i].imageLoaded) {
                    print("Prepare load image at index = \(i)")
                    productIdList.append(productStore.getProductIDby(index: i))
                }
            }
        }
        return productIdList
    }
    
    func prepareProductForShow() -> [Int] {
        let mainScrollIndex = 0
        var startIndex = 0
        var endIndex = 0
        var productIdList : [Int] = []
        // check is empty?
        // check product count?
        if( mainScrollIndex == 0) {
            startIndex = 0
            endIndex = 0 + 5
            for i in startIndex..<endIndex {
                if( !productStore.products[i].imageLoaded) {
                    print("index = \(i)")
                    productIdList.append(productStore.getProductIDby(index: i))
                }
            }
        }
        return productIdList
    }
    
    func loadImageList( productIdList : [Int] ) {
        if !productIdList.isEmpty {
            for i in productIdList {
                print("LoadImage ID in List = \(i)" )
                loadImage(productId: i)
            }
        }
    }
    
    func loadImage( productId : Int) {
//
//        guard let coverImageURL = self.productStore.products[productId].coverImageURL else {
//            fatalError("Cover ImageURL is not correct!")
//        }
        if let index = productStore.getIndexIDby(productID: productId) {
            guard let coverImageURL = self.productStore.products[index].coverImageURL else {
                fatalError("Cover ImageURL is not correct!")
            }
            
            URLSession.shared.dataTask(with: coverImageURL ) { data, resp, err in
                DispatchQueue.main.async {
                    self.productStore.setCoverImageById( ID: productId, image: UIImage(data: data!)! )
                    //                self.productStore.products[productId].coverLoaded = true
                    print("Cover id = \(productId) loaded")
                }
            }.resume()
            
            guard let thumbImageURL = self.productStore.products[index].thumbnailImageURL else {
                fatalError("Thumbnail ImageURL is not correct!")
            }
            
            URLSession.shared.dataTask(with: thumbImageURL) { data, resp, err in
                DispatchQueue.main.async {
                    self.productStore.setThumbImageById( ID: productId, image: UIImage(data: data!)! )
                    //                self.productStore.products[productId].thumbnailLoaded = true
                    print("Thumbnail id = \(productId) loaded")
                }
            }.resume()
        }
    }
    
}


