//
//  Constants.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 27.12.2021.
//

import Foundation
import SwiftUI

struct Constants {
    static let cardSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 100 : 150
    static let cardPadding: CGFloat = 5
    static let cardShadowRadius: CGFloat = 5
}
