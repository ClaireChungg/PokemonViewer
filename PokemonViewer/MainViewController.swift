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
    private let networkManager: NetworkManager = .shared
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        Task {
            self.pokemons = await networkManager.fetchData(0)
            tableView.reloadData()
        }
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
            pokemons[indexPath.row].sprite = await networkManager.fetchSprite(from: pokemons[indexPath.row].url)
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
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = DetailViewController()
        detailViewController.pokemon = pokemons[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pokemons.count - 1 && pokemons[indexPath.row].sprite != nil {
            let offset = pokemons.count
            Task {
                pokemons.append(contentsOf: await networkManager.fetchData(offset))
                tableView.reloadData()
            }
        }
    }
}
