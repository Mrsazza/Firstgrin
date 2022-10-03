//
//  BabyProfileViewModel.swift
//  Firstgrin
//
//  Created by Sazza on 15/9/22.
//

import Foundation
import FirebaseFirestoreSwift

class BabyProfileViewModel: ObservableObject{
    private var auth = FirebaseManager.shared.auth
    private var firestore = FirebaseManager.shared.firestore
    
    
    @Published var babyProfile = [BabyProfileModel]()
    @Published var profile = BabyProfileModel(name: "", age: "")
    @Published var errorMessage:String = ""
    
    func addBabyProfile(profile: BabyProfileModel){
        guard let uid = self.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        do {
            let documentRef = try self.firestore.collection("users")
                .document(uid)
                .collection("babyProfile").addDocument(from: profile)
            self.profile.id = documentRef.documentID
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func saveBabyProfile(){
        addBabyProfile(profile: profile)
    }
    
    func deleteBabyProfile(profile: BabyProfileModel){
        guard let uid = self.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        if let id = profile.id{
            self.firestore.collection("users")
                .document(uid)
                .collection("babyProfile")
                .document(id)
                .delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
        }
    }
    
    func fetchBabyProfile(){
             guard let uid = self.auth.currentUser?.uid else {
                 self.errorMessage = "Could not find firebase uid"
                 return
             }

             self.firestore.collection("users")
            .document(uid)
            .collection("babyProfile")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                self.babyProfile = documents.compactMap { (queryDocumentSnapshot) -> BabyProfileModel? in
                    return try? queryDocumentSnapshot.data(as: BabyProfileModel.self)
//                    // "Data" is, each data in the documents
//                    let data = queryDocumentSnapshot.data()
//                    let name = data["name"] as? String ?? ""
//                    let age = data["age"]  as? String ?? ""
//                    let babyProfile = BabyProfileModel(name: name, age: age)
//                    return babyProfile
                }
            }
         }
    
}
