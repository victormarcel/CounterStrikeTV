//
//  Services.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 12/07/25.
//

import CounterStrikeTVDomain
import Foundation

public final class Services: ServicesProtocol {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        static let indexToSplitMatchesToCache: Int = 3
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let networkingOperations: NetworkingOperationsProtocol
    private let cache = Cache.shared
    
    // MARK: - INITIALIZERS
    
    public init(networkingOperations: NetworkingOperationsProtocol) {
        self.networkingOperations = networkingOperations
    }
    
    // MARK: - INTERNAL METHODS
    
    public func fetchMatches(data: MatchesRequestData) async throws -> [Match] {
        let httpRequest = HttpRequest.fetchMatches(data)
        do {
            let matches: [Match] = try await networkingOperations.fetch(request: httpRequest)
            await handleMatchesCacheImage(matches)
            return matches
        } catch let error {
            throw error
        }
    }
    
    public func fetchTeam(data: TeamRequestData) async throws -> Team {
        let teamIdAsString = String(data.id)
        if let cachedTeam = cache.team(forKey: teamIdAsString) {
            return cachedTeam
        }
        
        let httpRequest = HttpRequest.fetchTeam(data)
        do {
            let response: [Team] = try await networkingOperations.fetch(request: httpRequest)
            guard let team = response.first else {
                throw NetworkingOperationsError.dataNotFound
            }
            try? cache.storeTeam(team, forKey: teamIdAsString)
            return team
        } catch let error {
            throw error
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleMatchesCacheImage(_ matches: [Match]) async {
        let firstMatchesToCache = Array(matches.prefix(Constants.indexToSplitMatchesToCache))
        let secondMatchesToCache = Array(matches.safeSuffix(from: Constants.indexToSplitMatchesToCache))
        
        await cacheMatchesImage(firstMatchesToCache)
        Task(priority: .background) {
            await cacheMatchesImage(secondMatchesToCache)
        }
    }
    
    private func cacheMatchesImage(_ matches: [Match]) async {
        let imagesCache = Cache.shared
        await withTaskGroup(
            of: (String, Data?).self
        ) {[weak self] taskGroup in
            guard let self else { return }
            
            for urlString in macheMatchesImageUrls(matches) {
                guard imagesCache.image(forKey: urlString) == nil else {
                    continue
                }
                taskGroup.addTask {
                    do {
                        let imageData = try await self.networkingOperations.fetch(from: urlString)
                        return (urlString, imageData)
                    } catch {
                        return (urlString, nil)
                    }
                }
            }
            
            for await (urlString, data) in taskGroup {
                if let imageData = data {
                    try? cache.storeImage(imageData, forKey: urlString)
                }
            }
        }
    }
    
    private func macheMatchesImageUrls(_ matches: [Match]) -> [String] {
        return matches.reduce(into: []) { urls, match in
            match.opponents.forEach({
                guard let imageUrl = $0.opponent.imageUrl, !imageUrl.isEmpty else { return }
                urls.append(imageUrl)
            })
        }
    }
}
