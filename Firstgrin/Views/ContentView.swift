//
//  ContentView.swift
//  Firstgrin
//
//  Created by Sazza on 31/8/22.
//

import SwiftUI

// TODO: MAKE USER LOGIN, SEND USER DATA TO FIRESTORE.

struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    var isTesting = true
    
    var body: some View {
        if isTesting{
            ArticleView()
        } else {
            switch viewRouter.currentPage {
            case .signUpPage:
                SignUpView()
            case .signInPage:
                SignInView()
            case .homePage:
                HomeTabView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewRouter())
    }
}
