//
//  UserDeckView.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 26.09.2021.
//

import SwiftUI

struct UserDeckView: View {
    // MARK: - Properties
    // Data source
    @Binding var deck: UserDeck
    @EnvironmentObject var deckStore: UserDecksStore
        
    // UI logic
    @State var showEditor = false
    //
    // MARK: - Constants
    //
    let gridItems = [GridItem(.adaptive(minimum: Constants.cardSize))]
    static let checkmarkSize: CGFloat = 30
    //
    // MARK: - Body
    //
    var body: some View {
        ScrollView {
            // Cards grid
            LazyVGrid(columns: gridItems) {
                ForEach($deck.cards) { card in
                    ZStack(alignment: .bottomTrailing ) {
                        // Card
                        CardView(card: card.wrappedValue)
                            .contextMenu {
                                Button("Remove", role: .destructive) {
                                    withAnimation {
                                        deckStore.remove(card: card.wrappedValue, from: deck)
                                    }
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle(deck.name)
        .padding(.horizontal)
        .toolbar {
            Button {
                showEditor = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .popover(isPresented: $showEditor) {
                DeckEditor(deck: $deck)
                    .frame(width: 300, height: 130)
            }
        }
    }
    //
    // MARK: - UI blocks
    //
    struct DeckEditor: View {
        @Binding var deck: UserDeck
        
        var body: some View {
            List {
                Section("Name") {
                    TextField("Name", text: $deck.name)
                }
            }
        }
    }
}
