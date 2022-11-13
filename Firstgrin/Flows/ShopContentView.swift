//
//  ShopContentView.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct ShopData {
    var product:Product = Product(uuid: "product123", image: Image("product01"), title: "Adidas Limited Edition 100P", price: 130.00, description: "Limited Edition Adidas are surely to bring you some street cred with these fresh kicks.", reviews: [Review(name: "John Smith", rating: 5.0, content: "This are sick! Best purchase I've made in a long time. Soooo slick!")])
    
     var items:[Product] = [
//        Product(uuid: "product01", image: Image("product01"), title: "Curology Shower Pack (3 Bottle Kit)", price: 29.99, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 4.7, content: "Finally a great lens! so good! Best purchase I've made in a long time. Soooo slick!")]),
        Product(uuid: "product02", image: Image("product02"), title: "EF-2 24mm f/2.8 Standard Lens", price: 99.00, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 3.7, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
        Product(uuid: "product03", image: Image("product03"), title: "Casio Signature Gold Classic Watch", price: 19.99, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
//        Product(uuid: "product04", image: Image("product04"), title: "HiTech GPS Smart Watch", price: 499.95, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
//        Product(uuid: "product05", image: Image("product05"), title: "Adidas Classic", price: 130.00, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
//        Product(uuid: "product06", image: Image("product06"), title: "Adidas Limited Edition Hu", price: 130.00, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper.", reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")])
     ]
    
    var cart:[Product] = []
    var favorites:[Product] = []
}

struct ShopContentView: View {
    @State var selectedTab : ShopTab = .shop
    @State var data = ShopData()
    
    var body: some View {
        ZStack {
            NavigationView{
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        HStack(spacing: 0){
                            ShopTopTab(tab: .shop, selectedTab: $selectedTab)
                            ShopTopTab(tab: .cart, selectedTab: $selectedTab)
                            ShopTopTab(tab: .wishlist, selectedTab: $selectedTab)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 36)
                    .foregroundColor(Color("blue"))
                    .padding()
                    .padding(.horizontal, 15)
                    
                    if selectedTab == .shop {
                        ShopView(products: $data.items, cart: $data.cart, favorites: $data.favorites)
                    } else if selectedTab == .cart {
                        CartView(items: $data.cart)
                    } else {
                        ShopView(products: $data.favorites, cart: $data.cart, favorites: $data.favorites)
                    }
                    Spacer()
                }
                .navigationTitle("Shop")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//struct ShopContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopContentView()
//    }
//}

enum ShopTab : String {
    case shop = "Shop"
    case cart = "Cart"
    case wishlist = "Wishlist"
}

struct ShopTopTab: View{
    @State var tab: ShopTab
    @Binding var selectedTab: ShopTab
    
    var body: some View{
        Button(action: {
            selectedTab = tab
        }, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(tab == selectedTab ? Color("orange") : .clear)
                Text(tab.rawValue)
                    .foregroundColor(tab == selectedTab ? .white : .black)
                    .font(.custom(Fonts.WorkSansBold, size: 14))
                
            }
        })
    }
}
