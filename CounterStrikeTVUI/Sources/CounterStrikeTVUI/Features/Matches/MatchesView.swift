//
//  MatchesView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

@MainActor
public protocol MatchesViewDelegate: AnyObject {
    
    func matchesView(_ view: MatchesView)
}

public struct MatchesView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let pageTitle = String(localized: "matches_page_title", bundle: .module)
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: MatchesViewModel
    
    @State private var matches: [Match] = []
    
    // MARK: - PUBLIC PROPERTIES
    
    public var delegate: MatchesViewDelegate?
    
    // MARK: - INITIALIZERS
    
    public init(viewModel: MatchesViewModel, delegate: MatchesViewDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: Metrics.Spacing.lg) {
                    ForEach(matches, id: \.id) { match in
                        MatchListItemView(match: match)
                            .onTapGesture {
                                delegate?.matchesView(self)
                            }
                    }
                }
                .padding(.top, Metrics.Spacing.md)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, Metrics.Spacing.lg)
        }
        .navigationTitle(Constants.pageTitle)
        .background(Color.appColor(.blue500))
        .task {
            await viewModel.fetchMatches()
        }
        .onReceive(viewModel.matchesServicePublisher) { state in
            handleViewState(state)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleViewState(_ state: ViewState<[Match]>) {
        switch state {
        case .loading:
            print("test")
        case .success(let matches):
            self.matches = matches
        case .error:
            print("Error")
        }
    }
}
