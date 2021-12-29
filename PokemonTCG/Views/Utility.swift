//
//  Utility.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 22.12.2021.
//

import SwiftUI
//
// MARK: - Blanked modifier
//
struct Blanked: ViewModifier {
    var isBlanked: Bool
    
    init(_ isBlanked: Bool) {
        self.isBlanked = isBlanked
    }
    
    func body(content: Content) -> some View {
        if isBlanked {
            Spacer()
        } else {
            content
        }
    }
}

extension View {
    func blanked(isBlanked: Bool) -> some View {
        self.modifier(Blanked(isBlanked))
    }
}
//
// MARK: - Magnifiy modifier
//
struct Magnify: ViewModifier {
    
    var isMagnified = false
    func body(content: Content) -> some View {
            if isMagnified {
                content
                    .frame(width: UIScreen.main.bounds.width)
            } else {
                content
            }
    }
}

extension View {
    func magnified(_ isMagnified: Bool) -> some View {
        self.modifier(Magnify(isMagnified: isMagnified))
    }
}
//
// MARK: - Edit mode extension
//
extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
