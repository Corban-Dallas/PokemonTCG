//
//  PokemonAPI.SearchParameters.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 25.12.2021.
//

import Foundation
//
// MARK: Parameters for search cards
//
extension PokemonAPI {
    struct SearchParameters: Equatable {
        //
        // MARK: - Search properties
        //
        var name = ""
        var type = ""
        
        var isEmpty: Bool {
            self == SearchParameters()
        }
    }
}
