//
//  MatchOpponentsView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

struct MatchOpponentsView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let firstTeamIndex: Int = 0
        static let secondTeamIndex: Int = 1
        
        enum MainStack {
            static let spacing: CGFloat = 20
        }
        
        enum MiddleSymbol {
            static let text = "vs"
            static let color = Color.white.opacity(0.5)
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    var opponents: [Team]
    
    // MARK: - UI
    
    var body: some View {
        HStack(spacing: Constants.MainStack.spacing)  {
            buildTeamView(index: Constants.firstTeamIndex)
            
            Text(Constants.MiddleSymbol.text)
                .foregroundStyle(Constants.MiddleSymbol.color)
            
            buildTeamView(index: Constants.secondTeamIndex)
        }
    }
    
    private func buildTeamView(index: Int) -> AnyView {
        guard let team = getTeamBy(index: index) else {
            return AnyView(EmptyView())
        }
        
        return AnyView(TeamIconAndTextView(team: team))
    }
    
    // MARK: - PRIVATE METHODS
    
    private func getTeamBy(index: Int) -> Team? {
        guard .zero..<opponents.count ~= index else {
            return nil
        }
    
        return opponents[index]
    }
}
