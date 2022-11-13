//
//  ShopView.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct ShopView: View {
    @Binding var products:[Product]
    @Binding var cart:[Product]
    @Binding var favorites:[Product]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                VStack(alignment: .center, spacing: 8) {
                    ForEach(products, id: \.uuid) { prod in
                        ProductDetail(product: prod, cart: self.$cart, favorites: self.$favorites)
                        
                    }
                    Spacer(minLength: 30)
                }
            }
        } 
    }
}

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView()
//    }
//}



