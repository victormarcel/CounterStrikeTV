//
//  PandaScoreConstants.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 14/07/25.
//

import Foundation

public enum PandaScoreConstants {
    
    static let basePath = "https://api.pandascore.co/csgo/"
    
    public enum Matches {
        public static let url = "\(PandaScoreConstants.basePath)matches"
    }
    
    public enum Teams {
        public static let url = "\(PandaScoreConstants.basePath)teams"
    }
    
    public enum Parameter {
        public static let arrayFormat = "%@[%@]"
        public static let descendingFormat = "-%@"
        
        public static let sort = "sort"
        public static let range = "range"
        public static let filter = "filter"
        public static let page = "page"
        public static let size = "size"
        public static let number = "number"
        public static let id = "id"
    }
}
