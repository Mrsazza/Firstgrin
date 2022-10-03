//
//  ImageUrlView.swift
//  Firstgrin
//
//  Created by Sazza on 28/9/22.
//

import SwiftUI

struct ImageUrlView: View {
    @EnvironmentObject var storageVM: StorageViewModel
    
    @State var url: String
    @State var image: UIImage?
    @State var width: CGFloat?
    @State var height: CGFloat?
    var body: some View {
        VStack{
            if image != nil {
                Image(uiImage: self.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width != nil ? width : nil, height: height != nil ? height : nil)
                    .clipped()
            } else {
                VStack{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .frame(width: width != nil ? width : nil, height: height != nil ? height : nil)
        .clipped()
        .task{
            fetchHeaderImage(url: url)
        }
    }
    func fetchHeaderImage(url:String) {
        storageVM.imageFrom(url: url) { image,url  in
            self.image = image
        }
    }
}

//struct ImageUrlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageUrlView()
//    }
//}
