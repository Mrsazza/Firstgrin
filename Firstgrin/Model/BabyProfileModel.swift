//
//  BabyProfileModel.swift
//  Firstgrin
//
//  Created by Sazza on 15/9/22.
//

import Foundation
import FirebaseFirestoreSwift

struct BabyProfileModel: Identifiable, Codable{
    
    /// Document Id is a protocol from FirebaseFirestoreSwift package
    /// Which we can use to map our id with the firebase provided id
    @DocumentID var id: String? = UUID().uuidString
    var name:String
    var age: String
    
    // We can use Coding keys as we can use it for json decoder
    enum CodingKeys: String, CodingKey{
        case name
        case age
    }
}
