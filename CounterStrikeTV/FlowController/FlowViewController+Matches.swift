//
//  FlowViewController+Matches.swift
//  CounterStrikeTV
//
//  Created by Victor Marcel on 17/07/25.
//

import CounterStrikeTVDomain
import CounterStrikeTVUI
import Foundation

extension FlowViewController: MatchesViewDelegate {
    
    func matchesView(_ view: MatchesView, didTap match: Match) {
        navigateToMatchView(match: match)
    }
}
