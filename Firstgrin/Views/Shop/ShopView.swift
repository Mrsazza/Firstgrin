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
        var prods: [[Product]] = []
        _ = (products).publisher
            .collect(products.count % 2 == 1 ? (products.count / 2) + 1 : (products.count / 2))
            .collect()
            .sink(receiveValue: { prods = $0 })
        
        return NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                HStack(alignment: .top, spacing: 10) {
                    if prods.count > 0 {
                        VStack(alignment: .center, spacing: 8) {
                            ForEach(prods[0], id: \.uuid) { prod in
                                NavigationLink(destination:
                                    ProductDetail(product: prod, cart: self.$cart, favorites: self.$favorites)
                                        .padding(.horizontal, 16)
                                        
                                ) {
                                    ProductCell(product: prod)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    if prods.count == 2 {
                        VStack(alignment: .center, spacing: 8) {
                            ForEach(prods[1], id: \.uuid) { prod in
                                NavigationLink(destination:
                                    ProductDetail(product: prod, cart: self.$cart, favorites: self.$favorites)
                                        .padding(.horizontal, 16)
                                ) {
                                    ProductCell(product: prod)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    if prods.count == 0 {

                        VStack(alignment: .center, spacing: 4) {
                            Spacer()
                            Image(systemName: "bag.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.gray)
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.bottom, 20)
                                //.font(Font.system(size: 16, weight: .bold, design: .rounded))
                            Text("No Products To Display")
                                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        
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



