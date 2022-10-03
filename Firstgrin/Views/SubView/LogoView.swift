//
//  LogoView.swift
//  Firstgrin
//
//  Created by Sazza on 3/9/22.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        // LOGO GOES HERE
        Image(systemName: "plus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
