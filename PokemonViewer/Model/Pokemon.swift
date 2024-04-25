//
//  Pokemon.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/18.
//

import Foundation

struct Pokemon: Codable {
    var name: String
    var url: URL?
    var sprite: PokemonSprite?
    var specy: PokemonSpecy?
}
