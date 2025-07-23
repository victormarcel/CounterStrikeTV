//
//  CacheObject.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 21/07/25.
//

import Foundation

class CacheObject<T> {
    
    // MARK: - INTERNAL PROPERTIES
    
    let value: T
    
    // MARK: - INITIALIZERS
    
    init(_ value: T) {
        self.value = value
    }
}
