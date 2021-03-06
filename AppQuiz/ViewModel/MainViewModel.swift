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
    @Published var bannerStore : BannerStore
    
    init() {
        productStore = ProductStore()
        bannerStore = BannerStore()
        productStore.sortById()
    }

    // Read Json data convert to productList in ProductStore struc
    func setProductStoreDataFromJson( jsonData : Data? ) {
        if( jsonData != nil ){
            let productListJson = try! JSONDecoder().decode( ProductListJson.self, from: jsonData!)
            productStore = ProductStore(from: productListJson)
            
        }
    }
    
    // update showing list while scroling down add 5 more products per time
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
    
    // Load index number of product prepare for loading Image
    func prepareProductForShow() -> [Int] {
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
    
    // Load Image by list of product func prepareProductForShow
    func loadImageList( productIdList : [Int] ) {
        if !productIdList.isEmpty {
            for i in productIdList {
                print("LoadImage ID in List = \(i)" )
                loadProductImage(productId: i)
            }
        }
    }
    
    // Load initiate Json file from URL
    func loadProductJson() {
        guard let url = URL(string: productJsobURLString ) else {
            print("Got problem in product URL String")
            return
        }
        
        URLSession.shared.dataTask(with: url){ (data,resp,err) in
            DispatchQueue.main.sync {
                let productListJson = try! JSONDecoder().decode( ProductListJson.self, from: data!)
                self.productStore = ProductStore(from: productListJson)
                self.loadImageList( productIdList: self.prepareProductForShow() )
                self.productStore.updateShowLists()
                print("Product Json Loaded")
            }
        }.resume()
    }
    
    // Load initiate Json file from URL
    func loadBannerJson() {
        guard let url = URL(string: bannerJsonURLString) else {
            print("Got problem in banner URL String")
            return
        }
        
        URLSession.shared.dataTask(with: url){ (data,resp,err) in
            DispatchQueue.main.sync {
                let bannerDataJson = try! JSONDecoder().decode( [BannerDataJson].self, from: data!)
                self.bannerStore = BannerStore(bannerData: bannerDataJson)
                self.loadBannerImage()
                print("Banner Json Loaded")
            }
        }.resume()
    }
    
    func loadBannerImage() {
        if !bannerStore.banners.isEmpty {
            for (index,banner) in bannerStore.banners.enumerated() {
                if(!banner.image_loaded) {
                    guard let bannerURL = URL( string:  banner.image_url_string ) else {
                            fatalError("Banner URL ID \(banner.id) is not correct!")
                        }
                        URLSession.shared.dataTask(with: bannerURL ) { data, resp, err in
                            DispatchQueue.main.async {
                                self.bannerStore.banners[index].image = UIImage(data: data!)!
                                self.bannerStore.banners[index].image_loaded = true
                                print("Banner id = \(banner.id) loaded")
                            }
                        }.resume()
                }
            }
        }
        else { print("Banner Store is empty cannot load images")}
    }
    
    func loadProductImage( productId : Int) {

        if let index = productStore.getIndexIDby(productID: productId) {
            guard let coverImageURL = self.productStore.products[index].coverImageURL else {
                fatalError("Cover ImageURL is not correct!")
            }
            
            URLSession.shared.dataTask(with: coverImageURL ) { data, resp, err in
                DispatchQueue.main.async {
                    self.productStore.setCoverImageById( ID: productId, image: UIImage(data: data!)! )
                    print("Cover id = \(productId) loaded")
                }
            }.resume()
            
            guard let thumbImageURL = self.productStore.products[index].thumbnailImageURL else {
                fatalError("Thumbnail ImageURL is not correct!")
            }
            
            URLSession.shared.dataTask(with: thumbImageURL) { data, resp, err in
                DispatchQueue.main.async {
                    self.productStore.setThumbImageById( ID: productId, image: UIImage(data: data!)! )
                    print("Thumbnail id = \(productId) loaded")
                }
            }.resume()
        }
    }
    
}


