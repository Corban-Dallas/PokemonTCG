//
//  Preview.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 22.08.2021.
//

import Foundation

struct Preview {
    static let card: Card = {
        let url = Bundle.main.url(forResource: "cards", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let wrapper = try! JSONDecoder().decode(Wrapper.self, from: data)
        return wrapper.cards.first!
    }()
}


//struct Preview {
//    static let deck: CardStore = {
//        let deck = CardStore()
//        let url = Bundle.main.url(forResource: "cards", withExtension: "json")!
////        deck.fetchCards(from: url)
//        return deck
//    }()
//    
//    static var cards: [Card] = {
//        let url = Bundle.main.url(forResource: "cards", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        let wrapper = try! JSONDecoder().decode(Wrapper.self, from: data)
//        return wrapper.cards }()
//}
