//
//  ContentView.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 20.08.2021.
//

import SwiftUI

struct ContentView: View {
    //
    // MARK: - Properties
    //
    // Data source
    @StateObject var cardStore = CardStore()
    @StateObject var deckStore = UserDecksStore()
    @StateObject var searchEngine = SearchEngine()
    
    // UI logic
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    //
    // MARK: - Body
    //
    var body: some View {
        if ContentView.isPhone {
            // Device is iPhone
            TabView {
                // Browser
                NavigationView {
                    cardsBrowser
                }
                .tabItem {
                    browserLabel
                }
                .navigationViewStyle(.automatic)
                // User decks
                NavigationView {
                    List {
                        userDecks
                    }
                    .navigationTitle("User decks")
                }
                .tabItem {
                    Label("Decks", systemImage: "lanyardcard")
                }
            }
        } else {
            // Divice is iPad
            NavigationView {
                List {
                    NavigationLink {
                        cardsBrowser
                    } label: {
                        browserLabel
                    }
                    Section("User decks") {
                        userDecks
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Pokemon TCG")
            }
        }
    }
    //
    // MARK: - UI Blocks
    //
    private var cardsBrowser: some View {
        CardsBrowser()
            .environmentObject(cardStore)
            .environmentObject(deckStore)
            .environmentObject(searchEngine)
    }
    
    private var userDecks: some View {
        ForEach($deckStore.decks) { deck in
            NavigationLink {
                UserDeckView(deck: deck)
            } label: {
                Label(deck.wrappedValue.name, systemImage: "lanyardcard")
            }
        }
        .onDelete { indices in
            deckStore.decks.remove(atOffsets: indices)
        }
    }
    
    private var browserLabel: some View {
        Label("Browser", systemImage: "square.grid.2x2")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
