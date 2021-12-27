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
        // MARK: - Parameters properties
        //
        var name = ""
        var type = Types.allTypes
        //
        // MARK: -
        enum Types: String, CaseIterable, Identifiable {
            case allTypes = "All types"
            case grass
            case fire
            case water
            
            var id: String { self.rawValue }
        }
        
        var isDefault: Bool {
            self == SearchParameters()
        }
    }
}
