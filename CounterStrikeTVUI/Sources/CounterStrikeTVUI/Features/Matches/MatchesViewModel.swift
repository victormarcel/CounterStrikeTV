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
    
    // MARK: - PRIVATE PROPERTIES
    
    private let service: ServicesProtocol
    private let matchesServicePassthrough = PassthroughSubject<ViewState<[Match]>, Never>()
    
    // MARK: - INTERNAL PROPERTIES
    
    var matchesServicePublisher: AnyPublisher<ViewState<[Match]>, Never> {
        return matchesServicePassthrough.eraseToAnyPublisher()
    }
    
    // MARK: - INITIALIZER
    
    public init(service: ServicesProtocol) {
        self.service = service
    }
    
    // MARK: - INTERNAL METHODS
    
    func fetchMatches() async {
        matchesServicePassthrough.send(.loading)
        do {
            let response = try await service.fetchMatches(data: .init(page: 1))
            matchesServicePassthrough.send(.success(response))
        } catch let error {
            matchesServicePassthrough.send(.error)
        }
    }
}
