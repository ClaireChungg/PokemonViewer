//
//  PokemonSpecy.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/22.
//

import Foundation

struct PokemonSpecy: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var genera: [Genus]
    var flavorTextEntries: [FlavorText]
    
    // MARK: - Computed properties
    var genus: String {
        genera.first(where: { $0.language.name == "zh-Hant" })?.genus ?? ""
    }
    
    var flavorText: String {
        flavorTextEntries
            .first(where: { $0.language.name == "zh-Hant" })?
            .flavorText.replacingOccurrences(of: "\n", with: "") ?? ""
    }
}

// MARK: - Nested structures
extension PokemonSpecy {
    struct Genus: Hashable, Codable {
        var genus: String
        var language: LanguageDetail
    }
    
    struct FlavorText: Hashable, Codable {
        var flavorText: String
        var language: LanguageDetail
        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
        }
    }
    
    struct LanguageDetail: Hashable, Codable {
        var name: String
    }
}

// MARK: - Coding Keys
extension PokemonSpecy {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case genera
        case flavorTextEntries = "flavor_text_entries"
    }
}
