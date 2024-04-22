//
//  MainViewController.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/17.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    private var tableView: UITableView!
    private var pokemons: [Pokemon] = []
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        Task {
            await fetchData(from: urlString)
            tableView.reloadData()
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
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self
        tableView.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        Task {
            pokemons[indexPath.row].sprite = await fetchDetailData(from: pokemons[indexPath.row].url)
            cell.setupContent(pokemons[indexPath.row].name, pokemons[indexPath.row].sprite?.imageUrl)
        }
        cell.cellShouldUpdate = {
            // call this to re-render cell
            // or you can use tableView.reloadData() instead (will update all cells)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.pokemon = pokemons[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
