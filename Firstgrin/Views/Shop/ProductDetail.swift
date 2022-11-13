//
//  ProductDetail.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct ProductDetail: View {
    var product:Product
    @Binding var cart:[Product]
    @Binding var favorites:[Product]
    @State private var showShareSheet = false
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingDescriptons : Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading ,spacing: 10) {
                Button {
                    withAnimation {
                        isShowingDescriptons.toggle()
                    }
                } label: {
                    product.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.horizontal, 3)
                        .frame(width: UIScreen.screenWidth * 0.9)
                       
                        .clipped()
                        .cornerRadius(20, corners: .topLeft)
                        .cornerRadius(20, corners: .topRight)
                }
                
                VStack(alignment: .leading ,spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.title)
                            .font(.custom(Fonts.WorkSansBold, size: 18))
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.custom(Fonts.WorkSansBold, size: 26))
                            .foregroundColor(Color("orange"))
                    }
                   
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            if self.favorites.contains(where: { (fav) -> Bool in
                                fav.uuid == self.product.uuid
                            }) {
                                self.favorites.removeAll { (fav) -> Bool in
                                    fav.uuid == self.product.uuid
                                }
                            } else {
                                self.favorites.append(self.product)
                            }
                        }) {
                            if self.favorites.contains(where: { (fav) -> Bool in
                                fav.uuid == product.uuid
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color.red)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(20)
                            } else {
                                Image(systemName: "heart")
                                    .foregroundColor(Color.black)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(20)
                            }
                        }
                       
                        Button(action: {
                            self.showShareSheet = !self.showShareSheet
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color.black)
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                        }

                        Spacer()

                        Button(action: {
                            if self.cart.contains(where: { (prod) -> Bool in
                                prod.uuid == self.product.uuid
                            }) {
                                self.cart.removeAll { (prod) -> Bool in
                                    prod.uuid == self.product.uuid
                                }
                            } else {
                                self.cart.append(self.product)
                            }
                        }) {
                            if self.cart.contains(where: { (prod) -> Bool in
                                prod.uuid == self.product.uuid
                            }) {
                                HStack(alignment: .center, spacing: 20) {
                                    Image(systemName: "checkmark")
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .foregroundColor(Color.white)
                                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                                .background(Color("orange"))
                                .cornerRadius(20)
                            } else {
                                HStack(alignment: .center, spacing: 20) {
                                    Image(systemName: "cart.fill")
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .foregroundColor(Color.white)
                                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                                .background(Color(red: 111/255, green: 115/255, blue: 210/255))
                                .cornerRadius(20)
                            }
                        }
                    }
                    
                    if isShowingDescriptons {
                        Text(product.description)
                            .font(.custom(Fonts.WorkSansBold, size: 14))
                            .padding(.all , 5)
                           
                    }
                }
                
                .padding(.all, 15)
            }
            .frame(width: UIScreen.screenWidth * 0.9)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(Color("offwhite"))
                    .padding(.horizontal, 3)
                    .shadow(radius: 2)
            )
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: ["\(self.product.title) - $\(String(format: "%.2f", self.product.price)) | \(self.product.description.prefix(100))..."])
            }
        }
        
        
    }
}


