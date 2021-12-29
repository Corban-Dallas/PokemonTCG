//
//  Card.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 20.08.2021.
//

import Foundation

struct Card: Identifiable {
    let id: String
    let name: String
    let smallImageUrl: String
    let largeImageUrl: String
}

// MARK: - Codable
extension Card: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case images
    }
    
    enum Images: String, CodingKey {
        case smallImageUrl = "small"
        case largeImageUrl = "large"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        let images = try values.nestedContainer(keyedBy: Images.self, forKey: .images)
        largeImageUrl = try images.decode(String.self, forKey: .largeImageUrl)
        smallImageUrl = try images.decode(String.self, forKey: .smallImageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        var images = container.nestedContainer(keyedBy: Images.self, forKey: .images)
        try images.encode(smallImageUrl, forKey: .smallImageUrl)
        try images.encode(largeImageUrl, forKey: .largeImageUrl)
    }
}
//
// MARK: - Equatable
extension Card: Equatable {
    // Some optimisation. We trast that server always provides us same
    // cards with same identifiers and all identifiers are unique.
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}
//
// MARK: - Hashable
//
extension Card: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
