//
//  RealtimeViewModel.swift
//  Firstgrin
//
//  Created by Sazza on 7/9/22.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
import SwiftUI

class RealtimeViewModel: ObservableObject{
    private var dbReferance : DatabaseReference = FirebaseManager.shared.database.reference()
    
    @Published var articles: ArticleModel?
    @Published var doctorsList: DoctorsList?
    
    var database : String{
        #if DEV
        return "release_version" //"test_version"
        #else
//        return "test_version"
        return "release_version"
        #endif
    }
    
    init(){
        fetchArticlesData()
        fetchDoctorsData()
    }
    
    func fetchArticlesData() {
        self.dbReferance.child(database).observeSingleEvent(of: .value) { snapshot in
            let homnew = snapshot.childSnapshot(forPath: "articles").value
           // guard let homeData = homnew as AnyObject? else { devPrint("Returning1"); return}
          //  guard let homeJsonData = homeData.jsonData else { devPrint("Returning2"); return}
            do {
//                devPrint("Here")
                let jsonData = try JSONSerialization.data(withJSONObject: homnew as Any)
                let result = try JSONDecoder().decode(ArticleModel.self, from: jsonData)
                self.articles = result
             //   self.homeDataLoaded = true
                print(result)
               // devPrint(self.docs)
            }
            catch let error{
                print("Article Data decoding error : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchDoctorsData() {
        self.dbReferance.child(database).observeSingleEvent(of: .value) { snapshot in
            let homnew = snapshot.childSnapshot(forPath: "doctors_list").value
           // guard let homeData = homnew as AnyObject? else { devPrint("Returning1"); return}
          //  guard let homeJsonData = homeData.jsonData else { devPrint("Returning2"); return}
            do {
//                devPrint("Here")
                let jsonData = try JSONSerialization.data(withJSONObject: homnew as Any)
                let result = try JSONDecoder().decode(DoctorsList.self, from: jsonData)
                self.doctorsList = result
             //   self.homeDataLoaded = true
                print(result)
               // devPrint(self.docs)
            }
            catch let error{
                print("Doctors List Data decoding error : \(error.localizedDescription)")
            }
        }
    }
}
