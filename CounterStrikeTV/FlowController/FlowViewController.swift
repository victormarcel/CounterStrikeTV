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
            static let backButtonLeftSpacing: CGFloat = -2
            static let font: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let backButtonImageName = "ic-arrow-left"
            static let titleMinimumScaleFactor: CGFloat = 0.7
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
        setupNavigationBarBackButton()
    }
    
    private func setupNavigationBarBackButton() {
        let yourBackImage = UIImage(
            named: Constants.NavigationBar.backButtonImageName
        )?.withAlignmentRectInsets(
            .init(
                top: .zero,
                left: Constants.NavigationBar.backButtonLeftSpacing,
                bottom: .zero,
                right: .zero
            )
        )
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    // MARK: - INTERNAL METHODS
    
    func navigateToMatchView(match: Match) {
        let matchViewController = factory.makeMatchView(match: match).wrappedByHostingController
        buildResizableNavTitleView(viewController: matchViewController, text: match.description)
        navigateTo(matchViewController)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func navigateTo(_ viewController: UIViewController) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func buildResizableNavTitleView(viewController: UIViewController, text: String) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = Constants.NavigationBar.font
        titleLabel.textColor = .white
        titleLabel.numberOfLines = .zero
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = Constants.NavigationBar.titleMinimumScaleFactor
        titleLabel.sizeToFit()
        
        viewController.navigationItem.titleView = titleLabel
    }
}
