//
//  PokemonAPI.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 28.08.2021.
//

import Foundation
import Combine
import UIKit
import Alamofire

struct PokemonAPI {
    //
    // MARK: Singelton initialization
    //
    static let shared = PokemonAPI()
    private init() { }
    //
    // MARK: - Properties
    //
    private let baseURL = "https://api.pokemontcg.io/v2/cards"
    //
    // MARK: - Fetch cards
    //
    func fetchCards(page: Int = 1, pageSize: Int = 25, filter: SearchParameters? = nil) async -> [Card]? {
        var parameters = [
            "page": String(page),
            "pageSize": String(pageSize)
        ]
        if let filter = filter {
            parameters["q"] = Self.filterUrlParameters(filter: filter)
        }
        return try? await AF.request(baseURL, parameters: parameters)
//            .cURLDescription() {
//                print($0.description)
//            }
            .validate()
            .serializingDecodable(Wrapper.self)
            .value.cards
    }
    //
    // MARK: - Utility
    //
    static private func filterUrlParameters(filter: SearchParameters) -> String {
        var question = ""
        if filter.type != .allTypes {
            question += "types:" + filter.type.rawValue
        }
        if !filter.name.isEmpty {
            question += " name:" + filter.name
        }
        return question
    }
}

