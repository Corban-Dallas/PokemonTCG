//
//  CardView.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 22.08.2021.
//

import SwiftUI
import Combine

struct CardView: View {
    //
    // MARK: - Properties
    //
    // Initislization
    let card: Card
    
    // UI Content
    @State var image: UIImage?
    @State private var cancellableImage: AnyCancellable?
    static let imagePlaceholder = UIImage(imageLiteralResourceName: "placeholder")
    
    let shadowRadius = Constants.cardShadowRadius
    let padding = Constants.cardPadding
    
    // UI logic
    @EnvironmentObject var decksStore: UserDecksStore
    @Environment(\.editMode) var editMode
    //
    // MARK: - Body
    //
    var body: some View {
        NavigationLink {
            CardDetail(card: card)
                .environmentObject(decksStore)
                .navigationTitle(card.name)
        } label: {
            Image(uiImage: image ?? CardView.imagePlaceholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(padding)
                .shadow(radius: shadowRadius)
                .onAppear {
                    guard let url = URL(string: card.smallImageUrl) else { return }
                    cancellableImage = CachedImageFetcher.shared.getImagePublisher(from: url)
                        .sink(receiveCompletion: { _ in  },
                              receiveValue: { image in self.image = image})
                }
                .onDisappear {
                    cancellableImage?.cancel()
                    self.image = nil
                }
        }
        .onDrag {
            card.itemProvider
        }
    }
}
//
// MARK: - Preview
//
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Preview.card
        CardView(card: card)
    }
}
