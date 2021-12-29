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
    @StateObject var decksStore = UserDecksStore()
    @StateObject var searchEngine = SearchEngine()
    
    // UI logic
    @State var showBrowser = false

    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    //
    // MARK: - Body
    //
    var body: some View {
        if ContentView.isPhone {
            // Device is iPhone
            iPhoneContent
        } else {
            // Divice is iPad
            iPadContentView
        }
    }
    //
    // MARK: - Shared UI Blocks
    //
    var cardsBrowser: some View {
        CardsBrowser()
            .environmentObject(cardStore)
            .environmentObject(decksStore)
            .environmentObject(searchEngine)
    }
    
    var userDecks: some View {
        ForEach($decksStore.decks) { deck in
            NavigationLink {
                UserDeckView(deck: deck)
                    .environmentObject(decksStore)
            } label: {
                Label(deck.wrappedValue.name, systemImage: "lanyardcard")
            }
        }
        .onDelete { indices in
            decksStore.decks.remove(atOffsets: indices)
        }
    }
    
    var browserLabel: some View {
        Label("Browser", systemImage: "square.grid.2x2")
    }
    
    var newDeckButton: some View {
        Button {
            withAnimation {
                decksStore.addDeck(UserDeck(name: "New deck"))
            }
        } label: {
            Label("New deck", systemImage: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
