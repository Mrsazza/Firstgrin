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
            ScrollView(showsIndicators: false){
                ForEach(realtimeVM.articles?.sections ?? [], id: \.id){ section in
                    VStack(spacing: 15) {
                        HStack{
                            Text("\(section.sectionName ?? "")")
                                .font(.custom(Fonts.WorkSansBold, size: 26))
                            Spacer()
                        }
                        ArticleSubView(section: section)
                    }
                    .padding(.leading, 20)
                }
            }
            .navigationTitle("Education")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ArticleSubView: View{
    @State var showSheet = false
    var section: Sections
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 5){
                ForEach(section.articleItems ?? [], id:\.id){ article in
                    VStack(alignment: .center, spacing: 0){
                        ImageUrlView(url: article.itemThumbnail ?? "", width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
                            .cornerRadius(10, corners: .topRight)
                            .cornerRadius(10, corners: .topLeft)
                        Text("\(article.itemTitle ?? "")")
                            .padding(.all,12)
                            .frame(width: UIScreen.screenWidth * 0.4)
                            .font(.custom(Fonts.WorkSansBold, size: 14))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .background(Color("offwhite"))
                    .cornerRadius(10, corners: .allCorners)
                    .onTapGesture {
                        showSheet.toggle()
                    }
                    .fullScreenCover(isPresented: $showSheet) {
                        ArticleDetailView(item: article)
                    }
                }
            }
//            .padding(.horizontal)
        }
    }
}

struct ArticleDetailView: View{
    @Environment(\.dismiss) var dismiss
    var topSectionHeight = UIScreen.screenHeight * 0.45
    
    @State var item:ArticleItem
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            ScrollView{
                ZStack{
                    ImageUrlView(url: item.itemThumbnail ?? "",width:UIScreen.screenWidth, height: topSectionHeight)
                            .overlay {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color.clear, Color.cyan.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                            }
                            .padding(.top, -35)
                    VStack {
                        HStack(spacing: -4){
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                Text("Back")
                                
                            })
                            Spacer()
                        }
                       
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top, 20)
                        Spacer()
                    }
                    
                    VStack {
                        Text(item.itemTitle ?? "")
                            .foregroundColor(.white)
                            .font(.custom(Fonts.WorkSansMedium, size: 32))
                            .shadow(radius: 3)
                            .multilineTextAlignment(.center)
                            .padding(.all, 30)
                            .padding(.top, 15)
                    }
                }
                .frame(height: topSectionHeight)
                .padding()
                
                ArticleDetailsBottom
                    
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private var ArticleDetailsBottom : some View {
        VStack(alignment: .leading, spacing: 15){
            ForEach(item.articleSections,id: \.id){articles in
                if articles.articleSectionHeader != nil {
                    Text(articles.articleSectionHeader!)
                        .foregroundColor(.black)
                        .font(.custom(Fonts.WorkSansMedium, size: 18))
                    
                }
                if articles.articleSectionImage != nil {
                    ImageUrlView(url: articles.articleSectionImage!)
                        .cornerRadius(10)
                }
                if !articles.articleSectionText.isEmpty{
                    ForEach(articles.articleSectionText,  id: \.id){texts in
                        Text(texts.sectionText.replacingOccurrences(of: "\\n", with: "\n"))
                            .font(.custom(Fonts.WorkSansMedium, size: 14))
                    }
                }
            }
        }
        .padding(.horizontal,30)
    }
}

