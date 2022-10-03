//
//  ViewRouter.swift
//  Firstgrin
//
//  Created by Sazza on 3/9/22.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .signInPage
    
}

enum Page {
    case signUpPage
    case signInPage
    case homePage
}
