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
//    
//    func makeCharactersViewController() -> CharactersListViewController {
//        let characterService = container.resolveInstance(MatchesServiceProtocol.self)
//        let imageDownloader = container.resolveInstance(ImageDownloaderProtocol.self)
//        let viewModel = CharactersListViewModel(characterService: characterService, imageDownloader: imageDownloader)
//        let viewController = CharactersListViewController(viewModel: viewModel)
//        
//        viewModel.delegate = viewController
//        
//        return viewController
//    }
    
    @MainActor
    func makeMatchesView(delegate: MatchesViewDelegate) -> MatchesView {
        let service = container.resolveInstance(ServicesProtocol.self)
        let viewModel = MatchesViewModel(service: service)
        
        return MatchesView(viewModel: viewModel, delegate: delegate)
    }
}


