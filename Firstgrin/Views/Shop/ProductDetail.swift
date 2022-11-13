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
            Color.white
                .cornerRadius(20, corners: .allCorners)
//                .padding(3)
                .shadow(radius: 1)
              
            VStack(alignment: .leading ,spacing: 10) {
                Button {
                    withAnimation {
                        isShowingDescriptons.toggle()
                    }
                } label: {
                    product.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
//                        .cornerRadius(20, corners: .allCorners)
                }
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
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(Color.black)
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                   
                    Button(action: {
                        self.showShareSheet = !self.showShareSheet
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color.black)
                            .frame(width: 40, height: 40, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
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
                            .cornerRadius(10)
                        } else {
                            HStack(alignment: .center, spacing: 20) {
                                Image(systemName: "cart.fill")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                            .background(Color(red: 111/255, green: 115/255, blue: 210/255))
                            .cornerRadius(10)
                        }
                    }
                }
                if isShowingDescriptons {
                    Text(product.description)
                        .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
            .padding(.all, 10)
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: ["\(self.product.title) - $\(String(format: "%.2f", self.product.price)) | \(self.product.description.prefix(100))..."])
            }
        }
        .frame(maxWidth: UIScreen.screenWidth * 0.9)
    }
}


