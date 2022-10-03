//
//  FirestoreViewModel.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import Foundation

class FirestoreViewModel: ObservableObject{
    private var auth = FirebaseManager.shared.auth
    private var firestore = FirebaseManager.shared.firestore
    @Published var errorMessage:String = ""
    
    @Published var user: User?
    
    
    // MARK: - FIRESTORE
   func storeUserInformation(email: String, uid: String) {
       guard let uid = self.auth.currentUser?.uid else { return }
        let userData = ["email": email, "uid": uid]
        self.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }

                print("Success")
            }
    }
    
   func fetchCurrentUser(){
            guard let uid = self.auth.currentUser?.uid else {
                self.errorMessage = "Could not find firebase uid"
                return
            }

        self.firestore.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user:", error)
                    return
                }

                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return

                }
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                self.user = User(uid: uid, email: email)
            }
        }
}
