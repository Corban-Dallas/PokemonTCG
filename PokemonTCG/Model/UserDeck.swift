//
//  UserDeck.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 25.09.2021.
//

import Foundation

struct UserDeck: Codable, Identifiable {
    private(set) var id = UUID()
    public var name: String
    public var cards = [Card]()
    private var nextID: Int = 0 // We need unique id for duplicate cards in deck
    
    init(name: String = "New deck") {
        self.name = name
    }
    
    mutating func appendCard(_ card: Card) {
        cards.append(Card(id: "\(nextID)",
                          name: card.name,
                          smallImageUrl: card.smallImageUrl,
                          largeImageUrl: card.largeImageUrl))
        nextID += 1
    }
    
    mutating func removeCard(at position: Int) {
        cards.remove(at: position)
    }
    mutating func removeCard(_ card: Card) {
        if let index = cards.firstIndex(where: {card.id == $0.id}) {
            cards.remove(at: index)
        }
    }
    mutating func removeAllCards() {
        cards.removeAll()
    }
}
