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
    @EnvironmentObject var decksStore: UserDecksStore
    
    // UI logic and content
    @State private var cancellableImage: AnyCancellable?
    @State private var image: UIImage?
    private var previewImage: UIImage
    static let imagePlaceholder = UIImage(imageLiteralResourceName: "placeholder")
    //
    // MARK: - Body
    //
    var body: some View {
        VStack {
            Image(uiImage: image ?? previewImage)
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if image == nil {
                    // While loading high resoulution image
                    ProgressView()
                }
                Menu {
                    Text("Add to deck")
                    ForEach(decksStore.decks) { deck in
                        Button(deck.name) { decksStore.addCard(card, to: deck)}
                    }
                    Button {
                        var deck = UserDeck(name: "New deck")
                        deck.appendCard(card)
                        decksStore.addDeck(deck)
                    } label: {
                        Label("Create new", systemImage: "plus")
                    }
                } label: {
                    Label("Add to deck", systemImage: "text.badge.plus")
                }
            }
        }
    }
    //
    // MARK: - UI blocks
    //
    private var addToDeckButton: some View {
        Button {
            // add to deck
        } label: {
            Label("Add to deck", systemImage: "text.badge.plus")
        }
    }
    //
    // MARK: - Initialization
    //
    init(card: Card) {
        self.card = card
        // Try read low resolution image for card from cache
        if let url = URL(string: card.smallImageUrl) {
            previewImage = CachedImageFetcher.shared.getImageFromCache(url: url) ?? CardView.imagePlaceholder
        } else {
            previewImage = CardView.imagePlaceholder
        }
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
