//
//  ContentView_iPad.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 29.12.2021.
//

import SwiftUI
//
// MARK: - Body view for iPad
//
extension ContentView {

    var iPadContentView: some View {
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
            .toolbar {
                ToolbarItem {
                    newDeckButton
                }
            }
            // Welcome view
            VStack {
                Text("Welcome").font(.title)
                Text("Please open sidebar and chose that you need").foregroundColor(.secondary)
                
            }
        }
    }
}
