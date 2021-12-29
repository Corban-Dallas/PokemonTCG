//
//  Card-DragAndDrop.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 29.12.2021.
//

import Foundation
import UniformTypeIdentifiers
//
// MARK: - Extension for Drag and Drop support
//
extension Card {
    static var draggableType = UTType(exportedAs: "Grigory-Krivyakin.PokemonTCG.card")
    
    var itemProvider: NSItemProvider {
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: Self.draggableType.identifier, visibility: .all) {
            do {
                let data = try JSONEncoder().encode(self)
                $0(data, nil)
            } catch {
                $0(nil, error)
            }
            return nil
        }
        return provider
    }
    
    static func fromItemProvider(_ provider: NSItemProvider, complition: @escaping (Card?) -> Void) {
        if let identifier = provider.registeredTypeIdentifiers.first,
              identifier == self.draggableType.identifier {
            provider.loadDataRepresentation(forTypeIdentifier: identifier) { (data, error) in
                guard let data = data else { return }
                let decoder = JSONDecoder()
                guard let card = try? decoder.decode(Card.self, from: data) else { return }
                complition(card)
            }
        } else {
            complition(nil)
            return
        }
    }

}
