//
//  MatchListItemView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

struct MatchListItemView: View {
    
    private enum Constants {
        
        static let defaultViewCornerRadius: CGFloat = 16
        
        enum MainStack {
            static let spacing: CGFloat = 18.5
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    let match: Match
    
    private var opponents: [Team] {
        match.opponents.compactMap { $0.opponent }
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Constants.MainStack.spacing) {
            matchTimeView
            
            MatchOpponentsView(opponents: opponents)
            
            leagueSerieStackView
        }
        .background(Color.appColor(.blue300))
        .roundedCorners(Constants.defaultViewCornerRadius)
    }
    
    @ViewBuilder
    var matchTimeView: some View {
        HStack() {
            Spacer()
            
            Rectangle()
                .fill(.red)
                .frame(width: 43, height: 25)
                .roundedCorners(Constants.defaultViewCornerRadius, corners: [.topRight, .bottomLeft])
        }
    }
    
    @ViewBuilder
    var leagueSerieStackView: some View {
        VStack(spacing: Metrics.Spacing.none) {
            Divider()
                .background(.white)
            
            HStack(spacing: Metrics.Spacing.md) {
                WebImageView(url: "https://cdn.pandascore.co/images/league/image/5373/555px-mesa_asian_masters_2025_lightmode-png")
                    .frame(width: Metrics.Size.sm, height: Metrics.Size.sm)
                
                Text("League + serie")
                    .foregroundStyle(.white)
                    .textStyle(fontSize: 8, color: .white)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.leading, 16)
        }
    }
}
