//
//  AppQuizApp.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 5/7/21.
//

import SwiftUI

@main
struct AppQuizApp: App {
    
    let mainVM : MainViewModel
//    @escaping var loading : Bool = false
    
    init() {
        mainVM = MainViewModel()
//        mainVM.setProductStoreDataFromJson(jsonData: listJson.data(using: .utf8) )
        mainVM.loadProductJson()
        mainVM.loadBannerJson()
//        mainVM.loadImageList( productIdList: mainVM.prepareProductForShow() )
        print("Number of All Products =  \(mainVM.productStore.products.count)" )
//        mainVM.productStore.updateShowLists()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            // Deley on Appear
//            self.loading = true
        }
    }
    
    var body: some Scene {
        WindowGroup {
                ContentView(mainVM: mainVM)
        }
    
    }
}
