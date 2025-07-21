//
//  AsyncCachedImage.swift
//  picklerick
//
//  Created by Miki on 21/7/25.
//

import SwiftUI

struct AsyncCachedImage: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat

    @State private var image: UIImage?
    @State private var hasError = false

    var body: some View {
   
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if hasError {
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
            } else {
                ProgressView()
                    .frame(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.setImage(uiImage, for: url)
                    await MainActor.run {
                        self.image = uiImage
                    }
                } else {
                    await MainActor.run { self.hasError = true }
                }
            } catch {
                await MainActor.run { self.hasError = true }
                print( "Image load failed: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AsyncCachedImage(
        url: URL(
            string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
        )!,
        width: 150,
        height: 150
    )
}
