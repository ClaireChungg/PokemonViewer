//
//  Pokemon.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/18.
//

import Foundation

struct PokemonResponse: Codable {
    var results: [Pokemon]
}

struct Pokemon: Codable {
    var name: String
    var url: URL?
}
