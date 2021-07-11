//
//  BannerModel.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 10/7/21.
//

import Foundation
import UIKit


let bannerJsonURLString = "https://60b7316f17d1dc0017b89435.mockapi.io/api/v1/banner"

struct BannerStore {
    
    var banners : [Banner] = []
    var bannerLoadComplete : Bool = false
    
    init( bannerData : [BannerDataJson]) {
        let sortedBannerData = bannerData.sorted{ $0.id < $1.id }
        for data in sortedBannerData {
            let banner = Banner(id: data.id,
                                image_url_string: data.image_url,
                                image_url: nil
            )
            banners.append(banner)
        }
    }
    
    var isAllBannerLoaded : Bool {
        let bannerCheck = banners.filter {$0.image_loaded}
//        let  check = (bannerCheck.count == banners.count) && banners.count > 0
//        print( check ? "Image Loaded" : "Image Loading")
//        print( "\(bannerCheck.count) vs \(banners.count)")
        return (bannerCheck.count == banners.count) && banners.count > 0
    }
    
    init (){
        
    }
}

struct Banner : Identifiable{
    var id : String
    var image_url_string : String
    var image : UIImage?
    var image_url : URL?
    var image_loaded : Bool = false
}

struct BannerDataJson : Codable {
    var id : String
    var image_url : String
}

