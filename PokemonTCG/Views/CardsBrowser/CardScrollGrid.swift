//
//  CardVGrid.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 26.12.2021.
//

import SwiftUI
import OrderedCollections

//
// MARK: - Infinte verticaly scrolled grid of cards
//
struct CardScrollGrid: View {
    //
    // MARK: - Properties
    //
    // Initializing parameters
    @Binding var cards: OrderedSet<Card>
    var onScrolledAtBottom: () async -> Void
    var loadingIsAvailable: Bool
    
    @EnvironmentObject var decksStore: UserDecksStore
    //
    // MARK: - Constants
    //
    private let gridItems = [GridItem(.adaptive(minimum: Constants.cardSize))]
    //
    // MARK: - Body
    //
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 0) {
                ForEach(cards) { card in
                    CardView(card: card)
                        .onAppear {
                            if cards.last == card {
                                Task { await onScrolledAtBottom() }
                            }
                        }
                        .contextMenu {
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
                        }
                }
            }
            .padding(.horizontal)
            if loadingIsAvailable {
                ProgressView()
            }
        }
        .onAppear {
            if loadingIsAvailable, cards.isEmpty {
                print("Download first page")
                Task { await onScrolledAtBottom() }
            }
        }
    }
}

//struct CardVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        CardScrollGrid()
//    }
//}
