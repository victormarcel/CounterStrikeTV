//
//  Array+Extensions.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation

public extension Array {
    
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func safeSuffix(from index: Int) -> ArraySlice<Element> {
        guard index <= self.count else { return [] }
        return self.suffix(from: index)
    }
}
