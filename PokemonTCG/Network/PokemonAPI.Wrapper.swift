//
//  PokemonAPI.Wrapper.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 25.12.2021.
//

import Foundation
//
// MARK: Cards respond wrapper
//
struct Wrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case cards = "data"
    }
    let cards: [Card]
}
