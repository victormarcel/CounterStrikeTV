//
//  ErrorFeedbackView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 20/07/25.
//

import SwiftUI

struct ErrorFeedbackView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let text = "matches_error_feedback_text".localizedBy(bundle: .module)
        static let buttonText = "reload".localizedBy(bundle: .main).capitalized
        static let fontSize: CGFloat = 16
    }
    
    // MARK: - INTERNAL PROPERTIES
    
    let action: () -> Void
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Metrics.Spacing.sm) {
            Text(Constants.text)
                .textStyle(fontSize: Constants.fontSize, color: .white)
            
            Button(action: action) {
                Text(Constants.buttonText)
                    .textStyle(fontSize: Constants.fontSize, color: .appColor(.purple200))
            }
        }
        .fullContainerCenter()
    }
}
