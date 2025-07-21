//
//  HttpRequestProtocol.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 27/05/25.
//

import CounterStrikeTVDomain
import Foundation

public protocol HttpRequestProtocol {
    
    var url: String { get }
    var method: HttpMethod { get }
    var parameters: [RequestParameter]? { get }
    var headers: [String: String]? { get }
}
