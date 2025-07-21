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
    
    func matchesView(_ view: MatchesView, didTap match: Match)
}

public struct MatchesView: View {
    
    // MARK: - ALIASES
    
    typealias MatchesViewState = MatchesViewModel.MatchesViewState
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let pageTitle = "matches".localizedBy(bundle: .module).capitalized
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    @StateObject private var viewModel: MatchesViewModel
    
    @State private var isFetchingFirstPage = false
    @State private var isFetchingNextPage = false
    @State private var wasFirstPageFetched = false
    @State private var hasMatchesFetchFailed = false
    
    // MARK: - PUBLIC PROPERTIES
    
    public var delegate: MatchesViewDelegate?
    
    // MARK: - INITIALIZERS
    
    public init(viewModel: MatchesViewModel, delegate: MatchesViewDelegate?) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.delegate = delegate
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack {
            if isFetchingFirstPage {
                ProgressView()
                    .tint(.white)
                    .fullContainerCenter()
            } else if hasMatchesFetchFailed {
                errorFeedbackView
            } else {
                scrollContentView
            }
        }
        .navigationTitle(Constants.pageTitle)
        .background(Color.appColor(.blue500))
        .task {
            guard !wasFirstPageFetched else {
                return
            }
            
            wasFirstPageFetched = true
            await viewModel.fetchFirstPage()
        }
        .onReceive(viewModel.matchesServicePublisher) { state in
            handleViewState(state)
        }
    }
    
    @State private var fetttt = false
    @ViewBuilder
    private var scrollContentView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Metrics.Spacing.lg) {
                    ForEach(Array(viewModel.matches.enumerated()), id: \.offset) { index, match in
                        MatchListItemView(match: match)
                            .onTapGesture {
                                delegate?.matchesView(self, didTap: match)
                            }
                            .task {
                                await fetchNextPageIfNeeded(currentIndex: index)
                            }
                    }
                    
                    if isFetchingNextPage {
                        ProgressView()
                    }
                }
                .padding(.top, Metrics.Spacing.md)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, Metrics.Spacing.lg)
            .refreshable {
                viewModel.matches = []
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
                    Task {
                        await viewModel.fetchFirstPage()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var errorFeedbackView: some View {
        ErrorFeedbackView {
            Task {
                await viewModel.fetchFirstPage()
            }
        }
        .fullContainerCenter()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleViewState(_ state: MatchesViewState) {
        switch state {
        case .firstPageState(let state):
            handleFirstPageState(state)
        case .nextPageState(let state):
            handleNextPageState(state)
        }
    }
    
    private func handleFirstPageState(_ state: ViewState<Void>) {
        switch state {
        case .loading:
            isFetchingFirstPage = true
        case .success:
            isFetchingFirstPage = false
        case .error:
            isFetchingFirstPage = false
            hasMatchesFetchFailed = true
        }
    }
    
    private func handleNextPageState(_ state: ViewState<Void>) {
        switch state {
        case .loading:
            isFetchingNextPage = true
        case .success:
            isFetchingNextPage = false
        case .error:
            isFetchingNextPage = false
        }
    }
    
    private func fetchNextPageIfNeeded(currentIndex: Int) async {
        guard let indexToFetchNextPage = viewModel.indexToFetchNextPage,
              currentIndex >= indexToFetchNextPage,
              !isFetchingNextPage else {
            return
        }
        
        await viewModel.fetchNextPage()
    }
}
