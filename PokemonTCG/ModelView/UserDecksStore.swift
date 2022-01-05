//
//  DeckStore.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 26.09.2021.
//

import Foundation

@MainActor class UserDecksStore: ObservableObject {
    //
    // MARK: - Properties
    @Published var decks = [UserDeck]()
    {
        // autosave all changes
        didSet { saveDecks() }
    }
    private let storageUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("decks.dat")
    //
    // MARK: - Initialization
    //
    init() {
        if !loadDecks() {
            // If failed to load decks
            decks.append(UserDeck(name: "User deck 1"))
        }
    }
    //
    // MARK: - Public mathods
    //
    public func remove(card: Card, from deck: UserDeck) {
        objectWillChange.send()
        guard let deckIndex = decks.firstIndex(where: { $0.id == deck.id })
        else { return }
        guard let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == card.id })
        else { return }
        
        decks[deckIndex].removeCard(at: cardIndex)
    }

    public func addCard(_ card: Card, to deck: UserDeck) {
        if let index = decks.firstIndex(where: {$0.id == deck.id}) {
            decks[index].appendCard(card)
        }
    }
    
    public func addDeck(_ deck: UserDeck) {
        decks.append(deck)

    }
    //
    // MARK: - Save and load decks
    //
    private func saveDecks() {
        do {
            let data = try JSONEncoder().encode(decks)
            try data.write(to: storageUrl)
        } catch {
            print("User deck save error: \(error.localizedDescription)")
        }
    }
    
    private func loadDecks() -> Bool {
        do {
            let data = try Data(contentsOf: storageUrl)
            decks = try JSONDecoder().decode([UserDeck].self, from: data)
            return true
        } catch {
            print("User deck load error: \(error.localizedDescription)")
            return false
        }
    }
}
