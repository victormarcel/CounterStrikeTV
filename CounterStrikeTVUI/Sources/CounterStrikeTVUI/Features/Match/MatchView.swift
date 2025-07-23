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
        
        static let firstTeamIndex: Int = .zero
        static let secondTeamIndex: Int = 1
        static let noDefinedTeamsFeedbackText = "match_view_no_defined_teams_tex".localizedBy(bundle: .module)
        static let noTeamPlayersFoundFeedbackText = "match_view_no_defined_teams_tex".localizedBy(bundle: .module)
        
        enum MainStack {
            static let spacing: CGFloat = 20
        }
        
        enum DateTime {
            static let size: CGFloat = 12
            static let ongoingText = "ongoing".localizedBy(bundle: .module).capitalized
        }
        
        enum FeedbackView {
            static let fontSize: CGFloat = 14
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
    
    private var firstOpponent: Team? {
        return opponents[safe: Constants.firstTeamIndex]
    }
    
    private var secondOpponent: Team? {
        return opponents[safe: Constants.secondTeamIndex]
    }
    
    @State private var isLoading = false
    @State private var hasFetchFailed = false
    
    // MARK: - INITIALIZERS
    
    public init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack {
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
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.MainStack.spacing) {
                MatchOpponentsView(opponents: viewModel.opponents)
                    .padding(.top, Metrics.Spacing.md)
                
                Text(timeText)
                    .textStyle(fontSize: Constants.DateTime.size, color: .white)
                    .bold()
                
                playersListView
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    @ViewBuilder
    private var playersListView: some View {
        if let firstOpponent {
            HStack(alignment: .top, spacing: Metrics.Spacing.md) {
                buildTeamPlayersView(firstOpponent, position: .trailing)
                
                buildTeamPlayersView(secondOpponent, position: .leading)
            }
            .padding(.bottom, Metrics.Spacing.xl)
        } else {
            buildFeedbackTextView(Constants.noDefinedTeamsFeedbackText)
        }
    }
    
    @ViewBuilder
    private func buildTeamPlayersView(_ team: Team?, position: PlayerItemListView.ImagePosition) -> some View {
        if let players = team?.players, !players.isEmpty {
            VStack(spacing: Metrics.Spacing.md) {
                ForEach(players, id: \.id) { player in
                    PlayerItemListView(player: player, imagePosition: position)
                }
            }
        } else {
            buildFeedbackTextView(Constants.noTeamPlayersFoundFeedbackText)
        }
        
    }
    
    @ViewBuilder
    private func buildFeedbackTextView(_ text: String) -> some View {
        Text(text)
            .textStyle(fontSize: Constants.FeedbackView.fontSize, color: .white)
            .multilineTextAlignment(.center)
            .padding(.vertical, Metrics.Spacing.md)
            .fullContainerCenter()
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
