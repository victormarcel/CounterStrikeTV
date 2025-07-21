//
//  MatchesRequestData.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 19/07/25.
//

import Foundation

public struct MatchesRequestData: ServiceRequestDataProtocol {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let comma = ","
        static let defaultPageSize: Int = 10
        
        enum Header {
            static let bearer = "Bearer"
            static let authorization = "Authorization"
        }
    }
    
    // MARK: - INITIALIZERS
    
    public init(page: Int) {
        self.page = page
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let page: Int
    
    private var sortByStatusAndBeginDateParameter: RequestParameter {
        (key: PandaScoreConstants.Parameter.sort,
         value: [buildDescendingOrderParameter(key: Match.CodingKeys.status.rawValue),
                 Match.CodingKeys.beginAt.rawValue].joined(separator: Constants.comma))
    }
    
    private var rangeByBeginDateParameter: RequestParameter {
        let key = buildArrayFormatParameter(key: PandaScoreConstants.Parameter.range,
                                            value: Match.CodingKeys.beginAt.rawValue)
        return (key: key, value: rangeByBeginDateParameterValue)
    }
    
    private var rangeByBeginDateParameterValue: String {
        guard let yesterdayDate = Date.now.subtract(days: Numbers.one)?.dateStringBy(format: .utc),
              let oneYearLaterDate = Date.now.add(years: Numbers.one)?.dateStringBy(format: .utc) else {
            return .empty
        }
        return [yesterdayDate, oneYearLaterDate].joined(separator: Constants.comma)
    }
    
    private var pageParameter: RequestParameter {
        let key = buildArrayFormatParameter(
            key: PandaScoreConstants.Parameter.page,
            value: PandaScoreConstants.Parameter.number
        )
        return (key: key, value: page)
    }
    
    private var runningAndNotEndedMatchesParameter: RequestParameter {
        let key = buildArrayFormatParameter(key: PandaScoreConstants.Parameter.filter,
                                            value: Match.CodingKeys.status.rawValue)
        let value = [MatchStatus.running.rawValue,
                     MatchStatus.notStarted.rawValue].joined(separator: Constants.comma)
        return (key: key, value: value)
    }
    
    private var pageSizeParameter: RequestParameter {
        let key = buildArrayFormatParameter(
            key: PandaScoreConstants.Parameter.page,
            value: PandaScoreConstants.Parameter.size
        )
        return (key: key, value: Constants.defaultPageSize)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func buildArrayFormatParameter(key: String, value: CVarArg) -> String {
        String(format: PandaScoreConstants.Parameter.arrayFormat, key, value)
    }
    
    private func buildDescendingOrderParameter(key: String) -> String {
        return String(format: PandaScoreConstants.Parameter.descendingFormat, key)
    }
    
    // MARK: - PUBLIC METHODS
    
    public func buildParameters() -> [RequestParameter]? {
        return [
            sortByStatusAndBeginDateParameter,
            rangeByBeginDateParameter,
            pageParameter,
            runningAndNotEndedMatchesParameter,
            pageSizeParameter
        ]
    }
    
    public func buildHeaders() -> [String: String]? {
        [Constants.Header.authorization: ServiceCredentials().pandaScoreApiAuthorization]
    }
}
