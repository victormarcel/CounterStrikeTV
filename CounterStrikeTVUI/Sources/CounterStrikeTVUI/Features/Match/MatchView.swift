//
//  MatchView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 17/07/25.
//

import SwiftUI

public struct MatchView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum MainStack {
            static let spacing: CGFloat = 20
        }
        
        enum DateTime {
            static let size: CGFloat = 12
        }
    }
    
    // MARK: - INITIALIZERS
    
    public init() {
        
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack(spacing: Constants.MainStack.spacing) {
//            MatchOpponentsView()
            
            Text("Hoje, 21:00")
                .textStyle(fontSize: Constants.DateTime.size, color: .white)
            
            HStack(spacing: Metrics.Spacing.md) {
                PlayerItemListView(imagePosition: .trailing)
                
                PlayerItemListView(imagePosition: .leading)
            }
            
            Spacer()
        }
        .navigationTitle("League + serie")
        .background(Color.appColor(.blue500))
    }
}

// MARK: - PREVIEW

#Preview {
    MatchView()
}
