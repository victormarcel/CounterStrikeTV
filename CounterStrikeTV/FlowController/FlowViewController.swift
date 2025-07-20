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
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    // MARK: - INTERNAL METHODS
    
    func navigateToMatchView() {
        let matchView = factory.makeMatchView()
        navigateTo(view: matchView)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func navigateTo(view: some View) {
        let viewController = view.wrappedByHostingController
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
