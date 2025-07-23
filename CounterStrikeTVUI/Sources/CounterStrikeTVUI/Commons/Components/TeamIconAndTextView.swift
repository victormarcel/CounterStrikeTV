//
//  TeamIconAndTextView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

struct TeamIconAndTextView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum MainStack {
            static let spacing: CGFloat = 10
        }
        
        enum Icon {
            static let size: CGFloat = 60
        }
        
        enum Text {
            static let fontSize: CGFloat = 10
            static let placeholder = "team_placeholder_text".localizedBy(bundle: .module)
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    let team: Team?
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Constants.MainStack.spacing) {
            buildIcon()
            
            Text(team?.name ?? Constants.Text.placeholder)
                .font(.system(size: Constants.Text.fontSize))
                .foregroundStyle(.white)
                .frame(maxWidth: Constants.Icon.size)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func buildIcon() -> some View {
        WebImageView(url: team?.imageUrl ?? .empty, placeholder: Image.icon(.shield))
            .frame(width: Constants.Icon.size, height: Constants.Icon.size)
    }
}
