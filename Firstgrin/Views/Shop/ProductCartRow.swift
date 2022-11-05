//
//  ProductCartRow.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct ProductCartRow: View {
    var item:Product
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            item.image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80, alignment: .center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 12) {
                Text("\(item.title)")
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                Text("$\(String.init(format: "%.2f", item.price))")
                    .font(Font.system(size: 17, weight: .bold, design: .rounded))
            }
            
            Spacer()
                /*
            
            VStack(alignment: .center, spacing: 12) {
                Text("1x")
                    .font(Font.system(size: 17, weight: .heavy, design: .rounded))
                    .frame(width: 30, height: 30, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                Text("S")
                    .font(Font.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.white)
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color(red: 199/255, green: 219/255, blue: 227/255))
                    .cornerRadius(35/2.0)
            }
                */
            
        }
    }
}

//struct ProductCartRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCartRow(item: $i)
//    }
//}
