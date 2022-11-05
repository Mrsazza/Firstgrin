//
//  ProductCell.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 5/11/22.
//

import SwiftUI

struct ProductCell: View {
    var product:Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            product.image
                .resizable()
                .scaledToFill()
                .cornerRadius(10)
                
            Text(product.title)
                .font(Font.system(size: 15, weight: .regular, design: .rounded))
            Text("$\(String(format: "%.2f", product.price))")
                .font(Font.system(size: 15, weight: .heavy, design: .rounded))
        }
        .aspectRatio(contentMode: .fit)

    }
}

//struct ProductCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCell()
//    }
//}
