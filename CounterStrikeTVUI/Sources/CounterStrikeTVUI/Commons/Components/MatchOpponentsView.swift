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
        
        enum Icon {
            static let size: CGFloat = 60
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    var opponents: [Team]
    
    // MARK: - UI
    
    var body: some View {
        HStack(spacing: Constants.MainStack.spacing)  {
            TeamIconAndTextView(team: opponents[safe: Constants.firstTeamIndex])
            
            Text(Constants.MiddleSymbol.text)
                .foregroundStyle(Constants.MiddleSymbol.color)
            
            TeamIconAndTextView(team: opponents[safe: Constants.secondTeamIndex])
        }
    }
}
