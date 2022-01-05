//
//  CardCollection.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 25.08.2021.
//

import SwiftUI

struct CardsBrowser: View {
    //
    // MARK: - Properties
    //
    @EnvironmentObject var cardStore: CardStore
    @EnvironmentObject var searchEngine: SearchEngine
    
    // UI logic
    @State private var mode: Mode = .browser
    @State private var showSearchParameters = false
    //
    // MARK: - Body
    //
    var body: some View {
        Group {
            // Main view content
            switch mode {
            case .browser:
                CardScrollGrid(cards: $cardStore.cards,
                               onScrolledAtBottom: cardStore.fetchNextPage,
                               loadingIsAvailable: cardStore.canLoadNextPage)
                    .navigationTitle("Browser")
            case .searchResults:
                SearchResults()
                    .navigationTitle("Search results")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if searchEngine.status != .idle {
                    clearSearchResultsButton
                }
                searchButton
            }
        }
        // Edit search parameters
        .sheet(isPresented: $showSearchParameters) {
            // On dismiss
            if searchEngine.status != .idle {
                mode = .searchResults
            } else {
                mode = .browser
            }
        } content: {
            SearchParametersView()
        }

    }
    //
    // MARK: - UI blocks
    //
    private var searchButton: some View {
        Button {
            showSearchParameters = true
        } label: {
            Label("Search", systemImage: mode == .browser ? "magnifyingglass" : "magnifyingglass.circle.fill")
        }
    }
    
    private var clearSearchResultsButton: some View {
        Button {
            withAnimation {
                searchEngine.resetResults()
                mode = .browser
            }
        } label: {
            Text("Clear")
        }
    }
    
    private enum Mode {
        case browser, searchResults
    }
    //
    // MARK: - Private utility methods
    //
    private func fetchFirstPage() {
        
    }
}
//
// MARK: - Preview
//
//struct CardsBrowser_Previews: PreviewProvider {
//    static var previews: some View {
//        CardsBrowser()
//            .environmentObject(CardStore())
//    }
//}
//struct CardsBrowser: View {
//    //
//    // MARK: - Properties
//    //
//    // Data souce
//    @EnvironmentObject var cardStore: CardStore
//    @EnvironmentObject var deckStore: UserDecksStore
//    @EnvironmentObject var searchEngine: SearchEngine
//
//    // UI logic
//    @State private var selectedCard: Card?
//    @State private var showFilter = false
//    private var navigationTitle: String { cardStore.filter == nil ? "Browser" : "Seach results" }
//
//    @Namespace var animation
//    //
//    // MARK: - Constants
//    //
//    let cardPadding: CGFloat = 5
//    let cardShadowRadius: CGFloat = 4
//    let cardSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 100 : 150
//    let blurRadius: CGFloat = 5.0
//    //
//    // MARK: - Body
//    //
//    var body: some View {
//        ZStack {
//            ScrollView {
//                cardsVGrid
//                if !cardStore.allShownCardsAreFetched {
//                    ProgressView()
//                }
//            }
//            .padding(.horizontal)
//            // Disable grid during detail view
//            .blur(radius: selectedCard == nil ? 0 : blurRadius)
//            .disabled(selectedCard != nil)
//
//            // Show detail view of taped card
//            if let card = selectedCard {
//                CardDetail(card: card)
//                    .matchedGeometryEffect(id: card.id, in: animation, anchor: .center)
//                    .onTapGesture {
//                        withAnimation {
//                            selectedCard = nil
//                        }
//                    }
//            }
//        }
//        .onAppear {
//            if cardStore.cards.isEmpty {
//                fetchNextPage()
//            }
//        }
//        .navigationTitle(navigationTitle)
//        .sheet(isPresented: $showFilter) {
//            // On dissmis
//            fetchNextPage()
//        } content: {
//            Filter(filter: cardStore.filter)
//                .environmentObject(cardStore)
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                filterButton
//            }
//        }
//    }
//
//    private func fetchNextPage() {
//        Task.init {
//            if cardStore.filter == nil {
//                await cardStore.fetchNextPage()
//            } else {
//                await cardStore.fetchFilteredCards()
//            }
//        }
//    }
//    //
//    // MARK: - UI blocks
//    //
//    private var cardsVGrid: some View {
//        LazyVGrid(columns: [GridItem(.adaptive(minimum: cardSize))]) {
//            ForEach(cardStore.shownCards) { card in
//                CardView(card: card)
//                    .matchedGeometryEffect(id: card.id, in: animation, anchor: .center)
//                    .onTapGesture {
//                        withAnimation {
//                            selectedCard = card
//                        }
//                    }
//                    .padding(cardPadding)
//                    .shadow(color: .black, radius: cardShadowRadius)
//
//                    .onAppear {
//                        if card.id == cardStore.shownCards.last!.id {
//                            fetchNextPage()
//                        }
//                    }
//                    .contextMenu {
//                        Text("Add to deck")
//                        ForEach(deckStore.decks) { deck in
//                            Button(deck.name) { deckStore.addCard(card, to: deck)}
//                        }
//                        Button {
//                            var deck = UserDeck(name: "New deck")
//                            deck.appendCard(card)
//                            deckStore.addDeck(deck)
//                        } label: {
//                            Label("Create new", systemImage: "plus")
//                        }
//                    }
//                    // to exclude two items with same id in one namespace we need hide a card
//                    .blanked(isBlanked: selectedCard?.id == card.id ? true : false)
//
//                }
//        }
//    }
//
//    private var filterButton: some View {
//        Button(action: {showFilter = true}, label: {
//            Image(systemName: "doc.text.magnifyingglass")
//        })
//    }
//}
