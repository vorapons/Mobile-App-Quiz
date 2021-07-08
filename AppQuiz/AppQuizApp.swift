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
        mainVM.setProductStoreDataFromJson(jsonData: listJson.data(using: .utf8) )
//            for i in 0..<5 {
//                mainVM.loadImage(productId: i)
//            }
        mainVM.loadImageList( productIdList: mainVM.prepareProductForShow2() )
        print("Number of All Products =  \(mainVM.productStore.products.count)" )
        mainVM.productStore.updateShowLists()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            // Deley on Appear
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(mainVM: mainVM)
//            TestImageView()
        }
    }
}


//let store = EmojiArtDocumentStore(named: "Emoji Art")
//
////    store.addDocument()
////    store.addDocument(named: "Hello World")
//init() {
////        store.addDocument()
////        store.addDocument(named: "Hello World")
//}
//
//
//var body: some Scene {
//    WindowGroup {
////            EmojiArtDocumentView(document: EmojiArtDocument())
//        EmojiArtDocumentChooser().environmentObject(store)
//    }
//}
//}
