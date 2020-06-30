//
//  ImageLoader.swift
//  YoutubePlaylistIOS
//
//  Created by Tanaka Mazivanhanga on 4/13/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    private var cancellable: AnyCancellable?

    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

    private var cache: ImageCache?
    private(set) var isLoading = false

       init(url: URL, cache: ImageCache? = nil) {
           self.url = url
           self.cache = cache
       }

       func load() {
          guard !isLoading else { return }

                  if let image = cache?[url] {
                      self.image = image
                      return
                  }

                  cancellable = URLSession.shared.dataTaskPublisher(for: url)
                      .map { UIImage(data: $0.data) }
                      .replaceError(with: nil)
                      // 3.
                      .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                                    receiveOutput: { [weak self] in self?.cache($0) },
                                    receiveCompletion: { [weak self] _ in self?.onFinish() },
                                    receiveCancel: { [weak self] in self?.onFinish() })
                    .subscribe(on: Self.imageProcessingQueue)
                      .receive(on: DispatchQueue.main)
                      .assign(to: \.image, on: self)
       }

       private func cache(_ image: UIImage?) {
           image.map { cache?[url] = $0 }
       }

        func cancel() {
            cancellable?.cancel()

    }
    private func onStart() {
           isLoading = true
       }

       private func onFinish() {
           isLoading = false
       }

    deinit {
        cancellable?.cancel()
    }
}

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let width,height: CGFloat

    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, width: CGFloat, height:CGFloat) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.width = width
        self.height = height
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var image: some View {
           Group {
               if loader.image != nil {
                   Image(uiImage: loader.image!)
                    .resizable().frame(width:width,height: height)
               } else {
                placeholder.frame(width:width,height: height)
               }
           }
       }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}


struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
