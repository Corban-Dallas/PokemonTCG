//
//  CardStore.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 20.08.2021.
//

import Foundation
import OrderedCollections
import Combine
import SwiftUI

@MainActor class CardStore: ObservableObject {
    //
    // MARK: - Properties
    //
    @Published var cards = OrderedSet<Card>()
    @Published var canLoadNextPage = true

    private var fetchedPages: Int = 0
    //
    // MARK: - Constants
    //
    private let pageSize = 25
    //
    // MARK: - Class public methods
    //
    public func fetchNextPage() async {
        if canLoadNextPage == false { return }
        print("[CardStore] Fetch \(fetchedPages + 1) page")

        guard let cards = await PokemonAPI.shared.fetchCards(page: fetchedPages + 1, pageSize: pageSize) else {
            print("[CardStore] Some error occured during cards fetching")
            canLoadNextPage = false
            return
        }
        if cards.count < pageSize {
            canLoadNextPage = false
            return
        }
        fetchedPages += 1
        self.cards.append(contentsOf: cards)
    }
}

extension CardStore {
    static func preview() -> CardStore {
        let store = CardStore()
        //store.cardsUrl = Bundle.main.url(forResource: "cards", withExtension: "json")!
        return store
    }
}
