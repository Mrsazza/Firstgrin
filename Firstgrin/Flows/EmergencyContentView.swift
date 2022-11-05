//
//  EmergencyContentView.swift
//  Firstgrin
//
//  Created by Sazza on 13/10/22.
//

import SwiftUI

struct EmergencyContentView: View {
    @EnvironmentObject private var manager: DataManager
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    HeaderTitle
                    EmergencyRow
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            realtimeVM.fetchEmergencyData()
        }
       
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            Text("Emergency").font(.largeTitle).bold()
            Spacer()
            Button {
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: "xmark").font(.system(size: 18, weight: .medium))
            }
        }.padding(.horizontal).foregroundColor(Color("TextColor"))
    }
    // Emergency Row
    private var EmergencyRow: some View{
        ScrollView {
            ForEach (realtimeVM.emergency?.emergencyRow ?? [], id:\.id){ row in
                VStack(alignment: .leading){
                    Text(row.emergencyRowTitle ?? "")
                    EmergencyGridView(emergencyRow: row)
                }
                .padding()
            }
        }
    }
    
}
struct EmergencyGridView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var emergencyRow: EmergencyRow
    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(emergencyRow.emergencySection ?? [], id: \.id) { item in
                    NavigationLink(destination: EmergencyMessageView(emergencySection: item)){
                        ZStack{
                            ImageUrlView(url: item.emergencySectionImage ?? "", width: UIScreen.screenWidth * 0.4, height: UIScreen.screenHeight*0.3)
                                .frame(height: UIScreen.screenHeight*0.3)
                                .cornerRadius(20, corners: .allCorners)
                            Text(item.emergencySectionTitle ?? "")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct EmergencyMessageView: View{
    @State var emergencySection: EmergencySection
    @State var showSheet = false
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View{
        ScrollView{
            Text(emergencySection.emergencySectionMessage?.replacingOccurrences(of: "\\n", with: "\n") ?? "")
                .font(.system(size: 14, weight: .regular,design: .rounded))
                .padding()
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(emergencySection.emergencyArticles ?? [], id: \.id) { article in
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(emergencySection.emergencySectionTitle ?? "")
    }
}

//struct EmergencyMessageRow: View{
//    @State var showSheet = false
//    var section: EmergencySection
//    var body: some View{
//        ScrollView(.horizontal, showsIndicators: false){
//            LazyHStack(spacing: 10){
//                ForEach(section.emergencyArticles ?? [], id:\.id){ article in
//                    ZStack(alignment: .bottomLeading){
//                        ImageUrlView(url: article.itemThumbnail ?? "",width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
//                            .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
//                            .cornerRadius(10)
//                        Text("\(article.itemTitle ?? "")")
//                            .font(.subheadline)
//                            .foregroundColor(.white)
//                            .shadow(color: .black, radius: 3, x: 2,y: 2)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(2)
//                            .padding(.all,8)
//                    }
//                    .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenWidth * 0.5)
//                    .onTapGesture {
//                        showSheet.toggle()
//                    }
//                    .fullScreenCover(isPresented: $showSheet) {
//                        ArticleDetailView(item: article)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}


struct EmergencyContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContentView()
    }
}
