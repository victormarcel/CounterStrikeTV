//
//  NetworkingOperationsError.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 28/05/25.
//

public enum NetworkingOperationsError: Error {
    
    case parseError(Error?)
    case invalidUrl
}
