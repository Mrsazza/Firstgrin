//
//  ColorsGridView.swift
//  Habit
//
//  Created by Apps4World on 1/23/22.
//

import SwiftUI

/// Show a list grid of colors from AppConfig
struct ColorsGridView: View {
    
    @Binding var selectedColorIndex: Int
    @Binding var showColorsGrid: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.opacity(showColorsGrid ? 0.7 : 0)
                .ignoresSafeArea().onTapGesture {
                    withAnimation { showColorsGrid = false }
                }
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height/1.5)
                VStack {
                    Text("Choose a Color").font(.title2).foregroundColor(Color("BackgroundColor"))
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 30) {
                            ForEach(0..<AppConfig.colors.count, id: \.self) { index in
                                ColorItem(atIndex: index)
                            }
                        }
                        Spacer()
                    }
                }.padding(.top).background(
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                        .foregroundColor(Color("LightColor")).ignoresSafeArea()
                )
            }.offset(y: showColorsGrid ? 0 : UIScreen.main.bounds.height)
        }
    }
    
    /// Color circle item
    private func ColorItem(atIndex index: Int) -> some View {
        ZStack {
            Circle().frame(width: 30, height: 30).padding(3)
                .foregroundColor(AppConfig.colors[index])
            if selectedColorIndex == index {
                Circle().stroke(Color.black, lineWidth: 2)
            }
        }.onTapGesture {
            selectedColorIndex = index
            withAnimation { showColorsGrid = false }
        }
    }
}

// MARK: - Preview UI
struct ColorsGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsGridViewPreview()
    }
    
    struct ColorsGridViewPreview: View {
        @State var index: Int = 0
        @State var showGrid: Bool = true
        var body: some View {
            ColorsGridView(selectedColorIndex: $index, showColorsGrid: $showGrid)
        }
    }
}
