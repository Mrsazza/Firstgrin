//
//  IconsGridView.swift
//  Habit
//
//  Created by Apps4World on 1/23/22.
//

import SwiftUI

/// Show a list grid of icons from AppConfig
struct IconsGridView: View {
    
    @Binding var selectedIconName: String
    @Binding var showIconsGrid: Bool
    @State var tintColor: Color = .black
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.opacity(showIconsGrid ? 0.7 : 0)
                .ignoresSafeArea().onTapGesture {
                    withAnimation { showIconsGrid = false }
                }
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height/1.7)
                VStack {
                    Text("Choose an Icon").font(.title2).foregroundColor(Color("BackgroundColor"))
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 30) {
                            ForEach(0..<AppConfig.icons.count, id: \.self) { index in
                                IconItem(atIndex: index)
                            }
                        }
                        Spacer()
                    }
                }.padding(.top).background(
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                        .foregroundColor(Color("LightColor")).ignoresSafeArea()
                )
            }.offset(y: showIconsGrid ? 0 : UIScreen.main.bounds.height)
        }
    }
    
    /// Icon item
    private func IconItem(atIndex index: Int) -> some View {
        let iconName = AppConfig.icons[index]
        return ZStack {
            Image(uiImage: UIImage(named: iconName)!)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30).padding(3)
                .foregroundColor(tintColor)
                .opacity(selectedIconName == iconName ? 1 : 0.3)
        }.onTapGesture {
            selectedIconName = iconName
            withAnimation { showIconsGrid = false }
        }
    }
}

// MARK: - Preview UI
struct IconsGridView_Previews: PreviewProvider {
    static var previews: some View {
        IconsGridViewPreview()
    }
    
    struct IconsGridViewPreview: View {
        @State var name: String = AppConfig.icons[0]
        @State var showGrid: Bool = true
        var body: some View {
            IconsGridView(selectedIconName: $name, showIconsGrid: $showGrid)
        }
    }
}
