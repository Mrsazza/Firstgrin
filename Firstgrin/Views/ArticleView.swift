//
//  ArticleView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    var body: some View {
        NavigationView{
//            VStack{
                ScrollView{
                    ForEach(realtimeVM.articles?.sections ?? [], id: \.id){ section in
                        VStack{
                            HStack{
                                Text("\(section.sectionName ?? "")")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical,8)
                            ArticleSubView(section: section)
                                .padding(.bottom,10)
                        }
//                    }
                }.listStyle(.plain)
            }
            .navigationTitle("Education")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct ArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleView()
//    }
//}

struct ArticleSubView: View{
    @State var showSheet = false
    var section: Sections
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 10){
                ForEach(section.articleItems ?? [], id:\.id){ article in
                    ZStack(alignment: .bottomLeading){
                        ImageUrlView(url: article.itemThumbnail ?? "",width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
                            .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
                            .cornerRadius(10)
                        Text("\(article.itemTitle ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3, x: 2,y: 2)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .padding(.all,8)
                    }
                    .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
                    .onTapGesture {
                        showSheet.toggle()
                    }
                    .fullScreenCover(isPresented: $showSheet) {
                        ArticleDetailView(item: article)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ArticleDetailView: View{
    @Environment(\.dismiss) var dismiss
    var topSectionHeight = UIScreen.screenHeight * 0.3
    @State var item:ArticleItem
    var body: some View{
        VStack{
            ZStack{
                ImageUrlView(url: item.itemThumbnail ?? "", height: topSectionHeight)
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        })
                    }
                    Spacer()
                    Text(item.itemTitle ?? "")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                }
            }
            .frame(height: topSectionHeight)
            ScrollView{
                Text(item.itemDescription ?? "")
                    .font(.body)
            }.padding()
        }
    }
}

