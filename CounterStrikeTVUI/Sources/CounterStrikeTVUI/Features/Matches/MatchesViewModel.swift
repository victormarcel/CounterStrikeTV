//
//  MatchesViewModel.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 19/07/25.
//

import Combine
import CounterStrikeTVDomain
import Foundation

@MainActor
public class MatchesViewModel: ObservableObject {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        static let validNumberOfOpponents: Int = 2
    }
    
    // MARK: - ENUM'S
    
    enum MatchesViewState {
        case firstPageState(ViewState<Void>)
        case nextPageState(ViewState<Void>)
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let service: ServicesProtocol
    private let matchesServicePassthrough = PassthroughSubject<MatchesViewState, Never>()
    private var nextMatchesPage: Int? = Numbers.one
    
    // MARK: - INTERNAL PROPERTIES
    
    @Published var matches: [Match] = []
    
    var matchesServicePublisher: AnyPublisher<MatchesViewState, Never> {
        return matchesServicePassthrough.eraseToAnyPublisher()
    }
    
    var indexToFetchNextPage: Int? {
        let matchIndexToFetchNextPage = matches.count - Numbers.four
        let isValidIndex = .zero..<matches.count ~= matchIndexToFetchNextPage
        guard isValidIndex else {
            return nil
        }
        
        return matchIndexToFetchNextPage
    }
    
    // MARK: - INITIALIZER
    
    public init(service: ServicesProtocol) {
        self.service = service
    }
    
    // MARK: - INTERNAL METHODS

    func fetchFirstPage() async {
        matchesServicePassthrough.send(.firstPageState(.loading))
        do {
            nextMatchesPage = Numbers.one
            let matches = try await fetchMatches()
            
            self.matches = matches
            nextMatchesPage = buildNextMatchesPage()
            
            matchesServicePassthrough.send(.firstPageState(.success(())))
        } catch {
            matchesServicePassthrough.send(.firstPageState(.error))
        }
    }
    
    func fetchNextPage() async {
        guard nextMatchesPage != nil else {
            return
        }
        
        matchesServicePassthrough.send(.nextPageState(.loading))
        do {
            let newMatches = try await fetchMatches()
            
            matches += newMatches
            nextMatchesPage = newMatches.isEmpty ? nil : buildNextMatchesPage()
            
            matchesServicePassthrough.send(.nextPageState(.success(())))
        } catch {
            matchesServicePassthrough.send(.nextPageState(.error))
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func fetchMatches() async throws -> [Match] {
        guard let nextMatchesPage else {
            return []
        }
        
        do {
            let matches = try await service.fetchMatches(data: .init(page: nextMatchesPage))
            return handleMatchesResponse(matches)
        } catch let error {
            throw error
        }
    }
    
    private func handleMatchesResponse(_ response: [Match]) -> [Match] {
        return response.filter { $0.opponents.count == Constants.validNumberOfOpponents }
    }
    
    private func buildNextMatchesPage() -> Int? {
        guard let nextMatchesPage else {
            return nil
        }
        
        return nextMatchesPage + Numbers.one
    }
}
