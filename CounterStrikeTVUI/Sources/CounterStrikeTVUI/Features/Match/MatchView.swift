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
        
        enum MainStack {
            static let spacing: CGFloat = 20
        }
        
        enum DateTime {
            static let size: CGFloat = 12
            static let ongoingText = "ongoing".localizedBy(bundle: .module).capitalized
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
        if let firstOpponent {
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: Metrics.Spacing.md) {
                    VStack(spacing: Metrics.Spacing.md) {
                        ForEach(firstOpponent.players ?? [], id: \.id) { player in
                            PlayerItemListView(player: player, imagePosition: .trailing)
                        }
                    }.if(secondOpponent == nil || secondOpponent?.players?.isEmpty ?? true) { content in
                        content
                            .padding(.trailing, proxy.size.width/CGFloat(Numbers.two))
                    }
                    
                    if let secondOpponent {
                        VStack(spacing: Metrics.Spacing.md) {
                            ForEach(secondOpponent.players ?? [], id: \.id) { player in
                                PlayerItemListView(player: player, imagePosition: .leading)
                            }
                        }
                        .if(firstOpponent.players?.isEmpty ?? true) { content in
                            content
                                .padding(.leading, proxy.size.width/CGFloat(Numbers.two))
                        }
                    }
                }
            }
        } else {
            EmptyView()
                .fullContainerCenter()
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
