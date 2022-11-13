//
//  ShopCard.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 10/11/22.
//

import SwiftUI

struct ShopCard: View {
   
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: UIScreen.screenWidth * 0.8, height:  UIScreen.screenHeight * 0.5)
                    .foregroundColor(Color.white)
                    .shadow(color: .black, radius: 1)
            )
        }
    }
}

struct ShopCard_Previews: PreviewProvider {
    static var previews: some View {
        ShopCard()
    }
}
