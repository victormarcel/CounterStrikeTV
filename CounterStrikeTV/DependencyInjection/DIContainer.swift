//
//  DIContainer.swift
//  CounterStrikeTV
//
//  Created by Victor Marcel on 29/05/25.
//

import Foundation
import Swinject
import CounterStrikeTVDomain
import CounterStrikeTVService

class DIContainer {
    
    // MARK: - STATIC PROPERTIES
    
    static let shared = DIContainer()
    
    // MARK: - INTERNAL PROPERTIES
    
    let container = Container()
    
    // MARK: - INITIALIZERS
    
    init() {
        registerServices()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func registerServices() {
        container.register(NetworkingOperationsProtocol.self) { _ in
            NetworkingOperations()
        }
        
        container.register(NetworkingOperationsProtocol.self) { (r, session: URLSession) in
            NetworkingOperations(session: session)
        }
        
        container.register(ServicesProtocol.self) { r in
            let networkingOperations = r.resolveInstance(NetworkingOperationsProtocol.self)
            return Services(networkingOperations: networkingOperations)
        }
    }
}
