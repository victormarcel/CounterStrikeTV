//
//  FlowViewController.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 29/05/25.
//

import CounterStrikeTVDomain
import CounterStrikeTVUI
import Foundation
import UIKit
import SwiftUI

@MainActor
final class FlowViewController {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum NavigationBar {
            static let font: UIFont = .systemFont(ofSize: 14, weight: .bold)
            static let backButtonImageName = "ic-arrow-left"
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let factory: ScreenFactory
    
    // MARK: - INTERNAL PROPERTIES
    
    var navigationController: UINavigationController?
    
    // MARK: - INITIALIZERS
    
    init(factory: ScreenFactory) {
        self.factory = factory
        
        let entryPointViewController = factory.makeMatchesView(delegate: self).wrappedByHostingController
        navigationController = .init(rootViewController: entryPointViewController)
        
        setupNavigationBarStyle()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupNavigationBarStyle() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = .appColor(.blue500)
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: Constants.NavigationBar.font
        ]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    // MARK: - INTERNAL METHODS
    
    func navigateToMatchView(match: Match) {
        let matchView = factory.makeMatchView(match: match)
        navigateTo(view: matchView)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func navigateTo(view: some View) {
        let viewController = view.wrappedByHostingController
        viewController.navigationItem.largeTitleDisplayMode = .never
        
        let yourBackImage = UIImage(named: Constants.NavigationBar.backButtonImageName)
        
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.backItem?.backButtonTitle = ""

        navigationController?.pushViewController(viewController, animated: true)
    }
}
