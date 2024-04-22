//
//  MainViewController.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/17.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    // MARK: - Properties
    private var tableView: UITableView!
    private var pokemons: [Pokemon] = []
    private let imageCache = NSCache<NSURL, UIImage>()
    private var detailFetchTask: Task<Void, Never>?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        Task {
            await fetchData(from: urlString)
        }
    }
    
    private func fetchData(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        struct PokemonResponse: Codable {
            var results: [Pokemon]
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
            self.pokemons = pokemonResponse.results
            self.tableView.reloadData()
        } catch {
            print(String(describing: error))
        }
    }
    
    private func fetchDetailData(from url: URL?) async -> PokemonSprite? {
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
    
    private func fetchImage(from url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        do {
            if let image = imageCache.object(forKey: url as NSURL) {
                return image
            } else {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return nil }
                self.imageCache.setObject(image, forKey: url as NSURL)
                return image
            }
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        detailFetchTask?.cancel()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        cell.nameLabel.text = pokemons[indexPath.row].name
        
        detailFetchTask = Task {
            pokemons[indexPath.row].sprite = await fetchDetailData(from: pokemons[indexPath.row].url)
            cell.thumbnailImageView.image = await fetchImage(from: pokemons[indexPath.row].sprite?.imageUrl)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
}
