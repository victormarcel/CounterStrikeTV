//
//  ImageByUrlView.swift
//  WebImageView
//
//  Created by Victor Marcel on 17/07/25.
//

import SwiftUI

//extension WebImageView {
//    func contentMode(_ contentMode: ContentMode) -> Self {
//        self.contentMode = contentMode
//        return self
//    }
//}

struct WebImageView: View {
    
    // MARK: - INTERNAL PROPERTIES
    
    let url: String
    var contentMode: ContentMode = .fit
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: url)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                } else if phase.error != nil {
                    errorView
                } else {
                    loadingView
                }
            }
        }
    }
    
    @ViewBuilder
    var errorView: some View {
        Color.gray
    }
    
    @ViewBuilder
    var loadingView: some View {
        ProgressView()
            .tint(.white)
    }
}
