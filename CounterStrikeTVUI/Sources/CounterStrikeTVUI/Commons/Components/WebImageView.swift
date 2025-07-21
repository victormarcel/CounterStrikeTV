//
//  ImageByUrlView.swift
//  WebImageView
//
//  Created by Victor Marcel on 17/07/25.
//

import SwiftUI

struct WebImageView: View {
    
    // MARK: - INTERNAL PROPERTIES
    
    let url: String
    let placeholder: Image?
    var contentMode: ContentMode
    
    // MARK: - INITIALIZER
    
    init(url: String, placeholder: Image? = nil, contentMode: ContentMode = .fit) {
        self.url = url
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: url)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                } else if phase.error != nil {
                    if let placeholder {
                        placeholder
                            .resizable()
                    } else {
                        Color.gray
                    }
                } else {
                    loadingView
                }
            }
        }
    }
    
    @ViewBuilder
    var loadingView: some View {
        ProgressView()
            .tint(.white)
    }
}
