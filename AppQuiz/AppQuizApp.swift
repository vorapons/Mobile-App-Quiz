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
    
    init() {
        mainVM = MainViewModel()
        mainVM.loadProductJson()
        mainVM.loadBannerJson()
        print("Number of All Products =  \(mainVM.productStore.products.count)" )
    }
    
    var body: some Scene {
        WindowGroup {
                ContentView(mainVM: mainVM)
        }
    
    }
}
