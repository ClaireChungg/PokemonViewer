//
//  MainViewController.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/17.
//

import UIKit
import Combine

class MainViewController: UIViewController, UITableViewDataSource {
    // MARK: - Properties
    private var tableView: UITableView!
    private var pokemons: [Pokemon] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        fetchData(from: urlString)
    }
    
    private func fetchData(from urlString: String) {
        struct PokemonResponse: Codable {
            var results: [Pokemon]
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { pokemonResponse in
                self.pokemons = pokemonResponse.results
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        guard let url = pokemons[indexPath.row].url else { return cell }
        cell.url = url
        cell.nameLabel.text = pokemons[indexPath.row].name
        cell.cellShouldUpdate = {
            // call this to re-render cell
            // or you can use tableView.reloadData() instead (will update all cells)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
}
