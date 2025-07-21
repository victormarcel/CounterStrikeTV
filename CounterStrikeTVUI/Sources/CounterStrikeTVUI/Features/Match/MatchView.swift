//
//  MatchView.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 17/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

public struct MatchView: View {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum MainStack {
            static let spacing: CGFloat = 20
        }
        
        enum DateTime {
            static let size: CGFloat = 12
            static let ongoingText = "ongoing".localizedBy(bundle: .module).uppercased()
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: MatchViewModel
    
    private var match: Match {
        viewModel.match
    }
    
    private var opponents: [Team] {
        viewModel.opponents
    }
    
    private var timeText: String {
        return match.status == .running ? Constants.DateTime.ongoingText : match.beginAtDescription
    }
    
    @State private var isLoading = false
    @State private var hasFetchFailed = false
    
    // MARK: - INITIALIZERS
    
    public init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack(spacing: Constants.MainStack.spacing) {
            if isLoading {
                ProgressView()
                    .tint(.white)
                    .fullContainerCenter()
            } else if hasFetchFailed {
                errorFeedbackView
            } else {
                contentView
            }
        }
        .navigationTitle(match.description)
        .background(Color.appColor(.blue500))
        .task {
            await viewModel.fetchTeams()
        }
        .onReceive(viewModel.matchServicePublisher) { state in
            handleViewState(state)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        MatchOpponentsView(opponents: viewModel.opponents)
            .padding(.top, Metrics.Spacing.md)
        
        Text(timeText)
            .textStyle(fontSize: Constants.DateTime.size, color: .white)
            .bold()
        
        playersListView
        
        Spacer()
    }
    
    @ViewBuilder
    private var playersListView: some View {
        if let firstOpponent = opponents.first,
           let secondOpponent = opponents.last {
            HStack(spacing: Metrics.Spacing.md) {
                VStack(spacing: Metrics.Spacing.md) {
                    ForEach(firstOpponent.players ?? [], id: \.id) { player in
                        PlayerItemListView(player: player, imagePosition: .trailing)
                    }
                }
                
                VStack(spacing: Metrics.Spacing.md) {
                    ForEach(secondOpponent.players ?? [], id: \.id) { player in
                        PlayerItemListView(player: player, imagePosition: .leading)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var errorFeedbackView: some View {
        ErrorFeedbackView {
            Task {
                await viewModel.fetchTeams()
            }
        }
        .fullContainerCenter()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleViewState(_ state: ViewState<Void>) {
        switch state {
        case .loading:
            isLoading = true
        case .success:
            isLoading = false
        case .error:
            isLoading = false
            hasFetchFailed = true
        }
    }
}
