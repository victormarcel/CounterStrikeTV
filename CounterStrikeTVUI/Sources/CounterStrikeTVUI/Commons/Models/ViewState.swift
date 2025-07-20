//
//  File.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 19/07/25.
//

import Foundation

enum ViewState<T> {
    
    case loading
    case success(T)
    case error
}
