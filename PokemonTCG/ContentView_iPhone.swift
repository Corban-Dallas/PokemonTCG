//
//  ContentView_iPhone.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 29.12.2021.
//

import SwiftUI
//
// MARK: - Body view for iPhone
//
extension ContentView {
    var iPhoneContent: some View {
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
                    Button("New deck") { }
                }
                .navigationTitle("User decks")
                .toolbar {
                    ToolbarItem {
                        newDeckButton
                    }
                }
            }
            .tabItem {
                Label("Decks", systemImage: "lanyardcard")
            }
        }
    }
}
