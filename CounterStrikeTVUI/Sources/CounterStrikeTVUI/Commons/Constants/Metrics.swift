
//
//  Metrics.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 17/07/25.
//

import Foundation

enum Metrics {
    
    /// A namespace for common spacing values used throughout the app.
    /// Use these constants to maintain consistent spacing in your layout.
    enum Spacing {
        
        /// No space (`0pt`)
        static let none: CGFloat = 0

        /// Extra-extra-small spacing (`2pt`) — useful for very tight elements like borders or icon gaps.
        static let xxs: CGFloat = 2

        /// Extra-small spacing (`4pt`) — for tight padding or micro-gaps between small elements.
        static let xs: CGFloat = 4

        /// Small spacing (`8pt`) — suitable for compact layouts, labels, and dense UIs.
        static let sm: CGFloat = 8

        /// Medium spacing (`16pt`) — the standard spacing for most layout separations.
        static let md: CGFloat = 16

        /// Large spacing (`24pt`) — for more generous padding and separation between sections.
        static let lg: CGFloat = 24

        /// Extra-large spacing (`32pt`) — great for major layout divisions or whitespace blocks.
        static let xl: CGFloat = 32

        /// Extra-extra-large spacing (`40pt`) — use for top-level structural separation or hero sections.
        static let xxl: CGFloat = 40
    }
    
    /// A namespace for common sizing values used across the app.
    /// Use these constants to standardize widths, heights, icons, and more.
    enum Size {
        
        /// Extra-extra-small size (`8pt`) — for icons or tiny elements.
        static let xxs: CGFloat = 8

        /// Extra-small size (`12pt`) — for compact elements or padding.
        static let xs: CGFloat = 12

        /// Small size (`16pt`) — commonly used for small buttons or icon frames.
        static let sm: CGFloat = 16

        /// Medium size (`24pt`) — standard for buttons, icons, or spacing blocks.
        static let md: CGFloat = 24

        /// Large size (`32pt`) — for prominent UI elements like large icons or images.
        static let lg: CGFloat = 32

        /// Extra-large size (`48pt`) — used for hero icons, buttons, or containers.
        static let xl: CGFloat = 48

        /// Extra-extra-large size (`64pt`) — ideal for large containers or layout blocks.
        static let xxl: CGFloat = 64

        /// Full size (`100%`) — a convenience for full-width or height (use with `.frame(maxWidth:)` or `.frame(maxHeight:)`).
        static let full: CGFloat = .infinity
    }
}
