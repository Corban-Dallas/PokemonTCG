//
//  PokemonAPI.Response.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 25.12.2021.
//

import Foundation
//
// MARK: Cards respond wrapper
//
struct Response<T: Decodable>: Decodable {
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    let data: T
}
