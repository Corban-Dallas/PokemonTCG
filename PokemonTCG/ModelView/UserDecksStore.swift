//
//  DeckStore.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 26.09.2021.
//

import Foundation

@MainActor class UserDecksStore: ObservableObject {
    @Published var decks = [UserDeck]()
    {
        didSet {
            storeInUserDefaults() // autosave all changes
        }
    }
    
    private let userDefaultsKey = "DeckStore"
    
    init() {
        restoreFromUserDefaults()
        if decks.isEmpty {
            decks.append(UserDeck(name: "User deck 1"))
            decks.append(UserDeck(name: "User deck 2"))
        }
    }
    
    public func remove(card: Card, from deck: UserDeck) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deck.id })
        else { return }
        guard let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == card.id })
        else { return }
        
//        decks[deckIndex].cards.remove(at: cardIndex)
        decks[deckIndex].removeCard(at: cardIndex)
    }
    
    private func storeInUserDefaults() {
        print("Store deck")
        if let data = try? JSONEncoder().encode(decks) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func restoreFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decks = try? JSONDecoder().decode(Array<UserDeck>.self, from: data) {
            self.decks = decks
        }
    }
    
    public func addCard(_ card: Card, to deck: UserDeck) {
        if let index = decks.firstIndex(where: {$0.id == deck.id}) {
            decks[index].appendCard(card)
        }
    }
    
    public func addDeck(_ deck: UserDeck) {
        decks.append(deck)

    }
}
