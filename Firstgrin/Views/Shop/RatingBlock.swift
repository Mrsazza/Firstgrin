//
//  RatingBlock.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct RatingBlock: View {
    var rating:Double
    var primaryColor:Color
    var secondaryColor:Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<5) { x in
                if self.rating > Double(x) {
                    if self.rating < Double(x) + 1 {
                        Image(systemName: "star.lefthalf.fill")
                            .foregroundColor(self.primaryColor)
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(self.primaryColor)
                    }
                } else {
                    Image(systemName: "star")
                        .foregroundColor(self.secondaryColor)
                }
            }
        }
    }
}

struct RatingBlock_Previews: PreviewProvider {
    static var rating:Double = 3.7
    static var primary:Color = Color.yellow
    static var secondary:Color = Color.gray
    static var previews: some View {
        RatingBlock(rating: rating, primaryColor: primary, secondaryColor: secondary)
    }
}
