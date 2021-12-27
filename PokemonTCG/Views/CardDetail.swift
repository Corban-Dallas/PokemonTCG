//
//  CardDetail.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 23.08.2021.
//

import SwiftUI
import Combine

struct CardDetail: View {
    //
    // MARK: - Properties
    //
    // Data source
    var card: Card

    // UI logic and content
    @State private var cancellableImage: AnyCancellable?
    @State private var image: UIImage?
    private var previewImage: UIImage?
    static let imagePlaceholder = UIImage(imageLiteralResourceName: "placeholder")
    //
    // MARK: - Body
    //
    var body: some View {
        VStack {
            Image(uiImage: image ?? (previewImage ?? CardView.imagePlaceholder))
                .resizable()
                .scaledToFit()
                .onAppear {
                    guard let url = URL(string: card.largeImageUrl) else { return }
                    cancellableImage = CachedImageFetcher.shared.getImagePublisher(from: url)
                        .sink(receiveCompletion: { _ in  },
                              receiveValue: { image in self.image = image})
                }
                .onDisappear {
                    cancellableImage?.cancel()
                    self.image = nil
                }
        }
    }
    //
    // MARK: - Initialization
    //
    init(card: Card) {
        self.card = card
        guard let url = URL(string: card.smallImageUrl) else { return }
        previewImage = CachedImageFetcher.shared.getImageFromCache(url: url)
    }
}
//
// MARK: - Preview
//
struct CardDetails_Previews: PreviewProvider {
    static var previews: some View {
        let card = Preview.card
        CardDetail(card: card)
    }
}
