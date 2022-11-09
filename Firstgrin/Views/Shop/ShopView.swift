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
    
    
    @State private var isPresented = false

    var body: some View {
        return NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 10) {
                    VStack(alignment: .center, spacing: 8) {
                        ForEach(products, id: \.uuid) { prod in
                            Button {
                                isPresented = true
                            } label: {
                                ProductCell(product: prod)
                            }
                            .fullScreenCover(isPresented: $isPresented) {
                                ProductDetail(product: prod, cart: self.$cart, favorites: self.$favorites)
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.bottom, 50)
            .navigationBarTitle("Catalog", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView()
//    }
//}



