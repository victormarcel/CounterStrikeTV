//
//  PlayerItemListView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 18/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

struct PlayerItemListView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum HStack {
            static let contentPadding: CGFloat = 12
        }
        
        enum Background {
            static let cornerRadius: CGFloat = 16
            static let height: CGFloat = 54
        }
        
        enum Info {
            static let nicknameFontSize: CGFloat = 14
            static let nameFontSize: CGFloat = 12
        }
        
        enum Image {
            static let size: CGFloat = 49
            static let cornerRadius: CGFloat = 8
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
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
    
    // MARK: - PRIVATE PROPERTIES
    
    private var playerRealName: String {
        [player.firstName ?? .empty, player.lastName ?? .empty].joined(separator: " ")
    }
    
    // MARK: - INTERNAL PROPERTIES
    
    var player: Player
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
            .padding(contentPaddingEdge, Constants.HStack.contentPadding)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        Color.appColor(.blue300)
            .roundedCorners(Constants.Background.cornerRadius, corners: backgroundRoundedCorners)
            .frame(height: Constants.Background.height)
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: infoViewAlignment, spacing: Metrics.Spacing.none) {
            Text(player.name)
                .textStyle(fontSize: Constants.Info.nicknameFontSize, color: .white)
                .bold()
            
            Text(playerRealName)
                .textStyle(fontSize: Constants.Info.nameFontSize, color: .appColor(.purple200))
        }
    }
    
    @ViewBuilder
    var imageView: some View {
        WebImageView(
            url: player.imageUrl ?? .empty,
            placeholder: Image.icon(.playerPlaceholder),
            contentMode: .fill
        )
        .frame(width: Constants.Image.size, height: Constants.Image.size)
        .roundedCorners(Constants.Image.cornerRadius)
    }
}
