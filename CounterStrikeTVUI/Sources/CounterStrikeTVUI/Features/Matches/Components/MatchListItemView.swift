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
        
        enum Time {
            static let fontSize: CGFloat = 8
            static let size: CGSize = .init(width: 43, height: 25)
        }
        
        enum LeagueAndSerie {
            static let fontSize: CGFloat = 8
            static let verticalPadding: CGFloat = 8
            static let leadingPadding: CGFloat = 16
        }
    }
    
    // MARK: - INTERNAL PROPERTIES
    
    let match: Match
    
    // MARK: - PRIVATE PROPERTIES
    
    private var opponents: [Team] {
        match.opponents.compactMap { $0.opponent }
    }
    
    private var tagColor: Color {
        match.status == .running ? .appColor(.red500) : .appColor(.gray400)
    }
    
    private var tagText: String {
        return match.status == .running ? "now".localizedBy(bundle: .module).uppercased() : match.beginAtDescription
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Constants.MainStack.spacing) {
            matchTimeView
            
            MatchOpponentsView(opponents: opponents)
            
            leagueAndSerieStackView
        }
        .background(Color.appColor(.blue300))
        .roundedCorners(Constants.defaultViewCornerRadius)
    }
    
    @ViewBuilder
    private var matchTimeView: some View {
        HStack() {
            Spacer()
            
            Text(tagText)
                .textStyle(fontSize: Constants.Time.fontSize, color: .white)
                .padding(Metrics.Spacing.sm)
                .fontWeight(.black)
                .background(tagColor)
                .roundedCorners(Constants.defaultViewCornerRadius, corners: [.topRight, .bottomLeft])
        }
    }
    
    @ViewBuilder
    private var leagueAndSerieStackView: some View {
        VStack(spacing: Metrics.Spacing.none) {
            Divider()
                .background(.white)
            
            HStack(spacing: Metrics.Spacing.sm) {
                leagueIconView
                
                Text(match.description)
                    .foregroundStyle(.white)
                    .textStyle(fontSize: Constants.LeagueAndSerie.fontSize, color: .white)
                
                Spacer()
            }
            .padding(.vertical, Constants.LeagueAndSerie.verticalPadding)
            .padding(.leading, Constants.LeagueAndSerie.leadingPadding)
        }
    }
    
    @ViewBuilder
    private var leagueIconView: some View {
        if let leagueImageUrl = match.league.imageUrl {
            WebImageView(url: leagueImageUrl)
                .frame(width: Metrics.Size.sm, height: Metrics.Size.sm)
        } else {
            Image.icon(.trophy)
                .resizable()
                .frame(width: Metrics.Size.sm, height: Metrics.Size.sm)
        }
    }
}
