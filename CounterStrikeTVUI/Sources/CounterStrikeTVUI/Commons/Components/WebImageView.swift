//
//  ImageByUrlView.swift
//  WebImageView
//
//  Created by Victor Marcel on 17/07/25.
//

import CounterStrikeTVDomain
import SwiftUI

struct WebImageView: View {
    
    // MARK: - INTERNAL PROPERTIES
    
    private let imagesCache = Cache.shared
    
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
        if let cachedImage = imagesCache.image(forKey: url) {
            buildImageView(cachedImage)
        } else if url.isEmpty {
            placeholderImageView
        } else {
            asyncImageView
        }
    }
    
    @ViewBuilder
    var asyncImageView: some View {
        AsyncImage(url: URL(string: url)) { response in
            if let image = response.image {
                cacheImage(image)
                return AnyView(buildImageView(image))
            } else if response.error != nil {
                return AnyView(placeholderImageView)
            } else {
                return AnyView(loadingView)
            }
        }
    }
    
    @ViewBuilder
    private func buildImageView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
    
    @ViewBuilder
    private var placeholderImageView: some View {
        if let placeholder {
            placeholder
                .resizable()
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ProgressView()
            .tint(.white)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func cacheImage(_ image: Image) {
        try? Cache.shared.storeImage(image, forKey: url)
    }
}
