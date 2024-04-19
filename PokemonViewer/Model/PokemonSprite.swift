//
//  Pokemon.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/17.
//

import Foundation

struct PokemonSprite: Hashable, Codable, Identifiable {
    var id: Int
    var name: String

    struct TypeElement: Hashable, Codable {
        struct TypeDetail: Hashable, Codable {
            var name: String
        }
        var type: TypeDetail
    }
    var types: [TypeElement]
    var typesNamesJoined: String {
        types.map { $0.type.name }.joined(separator: ", ")
    }

    struct Sprites: Hashable, Codable, Equatable {
        var imageUrl: URL?

        enum CodingKeys: String, CodingKey {
            case imageUrl = "front_default"
        }
    }
    var sprites: Sprites
    var imageUrl: URL? {
        sprites.imageUrl
    }
}
