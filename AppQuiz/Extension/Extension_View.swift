//
//  Extension_View.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 11/7/21.
//

import Foundation
import SwiftUI

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
