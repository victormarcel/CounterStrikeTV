//
//  ScreenFactory+Match.swift
//  CounterStrikeTV
//
//  Created by Victor Marcel on 20/07/25.
//

import CounterStrikeTVDomain
import CounterStrikeTVUI
import Foundation

extension ScreenFactory {
    
    @MainActor
    func makeMatchView(match: Match) -> MatchView {
        let service = container.resolveInstance(ServicesProtocol.self)
        let viewModel = MatchViewModel(match: match, service: service)
        
        return MatchView(viewModel: viewModel)
    }
}
