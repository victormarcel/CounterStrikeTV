//
//  ScreenFactory+Matches.swift
//  CounterStrikeTV
//
//  Created by Victor Marcel on 19/07/25.
//

import CounterStrikeTVDomain
import CounterStrikeTVUI
import Foundation

extension ScreenFactory {
    
    @MainActor
    func makeMatchesView(delegate: MatchesViewDelegate) -> MatchesView {
        let service = container.resolveInstance(ServicesProtocol.self)
        let viewModel = MatchesViewModel(service: service)
        
        return MatchesView(viewModel: viewModel, delegate: delegate)
    }
}
