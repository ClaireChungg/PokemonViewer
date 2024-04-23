//
//  NetworkManager.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/22.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private let imageCache = NSCache<NSURL, UIImage>()
    
    func fetchData(from urlString: String) async -> [Pokemon] {
        guard let url = URL(string: urlString) else { return [] }
        struct PokemonResponse: Codable {
            var results: [Pokemon]
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
            return pokemonResponse.results
        } catch {
            print(String(describing: error))
        }
        return []
    }
    
    func fetchSprite(from url: URL?) async -> PokemonSprite? {
        guard let url = url else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonSprite = try JSONDecoder().decode(PokemonSprite.self, from: data)
            return pokemonSprite
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    
    func fetchImage(from url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return cachedImage
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url as NSURL)
                return image
            }
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    
    func fetchSpecy(from urlString: String) async -> PokemonSpecy? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonSpecy = try JSONDecoder().decode(PokemonSpecy.self, from: data)
            return pokemonSpecy
        } catch {
            print(String(describing: error))
        }
        return nil
    }
}
