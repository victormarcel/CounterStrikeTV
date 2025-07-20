//
//  PlayerItemListView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 18/07/25.
//

import SwiftUI

struct PlayerItemListView: View {
    
    enum ImagePosition {

        case leading
        case trailing
        
        var edge: Edge.Set {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
        
        var oppositeEdge: Edge.Set {
            switch self {
            case .leading:
                return .trailing
            case .trailing:
                return .leading
            }
        }
    }
    
    private var infoViewAlignment: HorizontalAlignment {
        switch imagePosition {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
    
    private var backgroundRoundedCorners: UIRectCorner {
        switch imagePosition {
        case .leading:
            return [.topLeft, . bottomLeft]
        case .trailing:
            return [.topRight, . bottomRight]
        }
    }
    
    private var zStackAlignment: Alignment {
        switch imagePosition {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
    
    private var contentPaddingEdge: Edge.Set {
        switch imagePosition {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
    
    // MARK: - INTERNAL PROPERTIES
    
    var imagePosition: ImagePosition
    
    // MARK: - UI
    
    var body: some View {
        ZStack(alignment: zStackAlignment) {
            backgroundView
            
            HStack(alignment: .bottom, spacing: Metrics.Spacing.md) {
                if imagePosition == .leading {
                    imageView
                }
                
                infoView
                
                if imagePosition == .trailing {
                    imageView
                }
            }
            .offset(y: -Metrics.Spacing.sm)
            .padding(contentPaddingEdge, 12)
        }
        
//        ZStack(alignment: zStackAlignment) {
//            playerInfoView
//                .padding(imageAlignment.oppositeEdge, Metrics.Spacing.md)
//                .padding(imageAlignment.edge, 77)
//                .padding(.top, Metrics.Spacing.md)
//                .padding(.bottom, Metrics.Spacing.sm)
//                .background(Color.appColor(.blue300))
//                .roundedCorners(16, corners: playerInfoViewRoundedCorners)
//            
//            imageView
//                .padding(imageAlignment.edge, 12)
//                .offset(y: -Metrics.Spacing.sm)
//        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        Color.appColor(.blue300)
            .roundedCorners(16, corners: backgroundRoundedCorners)
            .frame(height: 54)
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: infoViewAlignment, spacing: Metrics.Spacing.none) {
            Text("Nickname")
                .textStyle(fontSize: 14, color: .white)
                .bold()
            
            Text("Nome de Jogador")
                .textStyle(fontSize: 12, color: .appColor(.purple200))
        }
    }
    
    @ViewBuilder
    var imageView: some View {
        WebImageView(url: "https://cdn.pandascore.co/images/player/image/21846/izaa_santos.png", contentMode: .fill)
            .frame(width: 49, height: 49)
            .roundedCorners(8)
    }
}

// MARK: - PREVIEW

#Preview {
    PlayerItemListView(imagePosition: .leading)
}
