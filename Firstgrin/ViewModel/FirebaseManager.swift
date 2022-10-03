//
//  FirebaseManager.swift
//  Firstgrin
//
//  Created by Sazza on 3/9/22.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore
// In order to work with SwiftUI Previews and Firebase, you'll need to make sure that FirebaseApp is never configured more than once. To do this, create a singleton FirebaseManager than manages the lifecycle of Firebase features.

class FirebaseManager:NSObject{
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let database: Database
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        self.database = Database.database()
        
        super.init()
    }
    
    // MARK: FIRESTORAGE
    
    // MARK: REALTIME
}
