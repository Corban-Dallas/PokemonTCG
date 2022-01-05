//
//  PokemonTCGApp.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 24.12.2021.
//

import SwiftUI

@main
struct PokemonTCGApp: App {
    @StateObject var cardStore = CardStore()
    @StateObject var decksStore = UserDecksStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cardStore)
                .environmentObject(decksStore)
        }
    }
}
