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
    private let baseURL = "https://api.pokemontcg.io/v2"
    //
    // MARK: - Public methods
    //
    func fetchCards(page: Int = 1, pageSize: Int = 25, filter: SearchParameters? = nil) async -> [Card]? {
        var parameters = [
            "page": String(page),
            "pageSize": String(pageSize)
        ]
        if let filter = filter {
            parameters["q"] = Self.filterUrlParameters(filter: filter)
        }
        return try? await AF.request(baseURL + "/cards", parameters: parameters)
            .validate()
            .serializingDecodable(Response<[Card]>.self)
            .value.data
    }
    // Request set of all available card types
    func fetchTypes() async -> Set<String>? {
        return try? await AF.request(baseURL + "/types")
            .validate()
            .serializingDecodable(Response<Set<String>>.self)
            .value.data
    }
    //
    // MARK: - Search properties
    //
    struct SearchParameters: Equatable {
        var name = ""
        var type = ""
        //
        // MARK: -
        //
        var isEmpty: Bool {
            self == SearchParameters()
        }
    }
    //
    // MARK: Respond wrapper
    //
    struct Response<T: Decodable>: Decodable {
        enum CodingKeys: String, CodingKey {
            case data = "data"
        }
        let data: T
    }
    //
    // MARK: - Utility
    //
    static private func filterUrlParameters(filter: SearchParameters) -> String {
        var question = ""
        if !filter.type.isEmpty {
            question += "types:" + filter.type
        }
        if !filter.name.isEmpty {
            question += " name:" + filter.name
        }
        return question
    }
}

