//
//  DetailViewController.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/22.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Properties
    var pokemon: Pokemon?
    var nameLabel = UILabel()
    var idLabel = UILabel()
    var thumbnailImageView = UIImageView()
    var descriptionLable = UILabel()
    let descriptionIconImageView = UIImageView(
        image: UIImage(systemName: "diamond.inset.filled")
    )
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNameAndIdLabels()
        setupImageView()
        
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemon?.sprite?.id ?? 1)"
        Task {
            await fetchSpecies(from: urlString)
            setupDescriptionLable()
        }
    }
    
    private func setupNameAndIdLabels() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, idLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = pokemon?.name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.text = "#" + String(format: "%04d", pokemon?.sprite?.id ?? 0 )
        idLabel.font = UIFont.systemFont(ofSize: 24)
        idLabel.textColor = .darkGray
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func setupImageView() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = .systemGray5
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        Task {
            thumbnailImageView.image = await fetchImage(from: pokemon?.sprite?.imageUrl)
        }
        
        view.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        ])
    }
    
    private func setupDescriptionLable() {
        descriptionIconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionIconImageView.tintColor = .darkGray
        descriptionIconImageView.contentMode = .scaleAspectFit
        
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionLable.text = pokemon?.specy?.flavorText
        descriptionLable.textColor = .darkGray
        descriptionLable.numberOfLines = 3
        
        view.addSubview(descriptionIconImageView)
        view.addSubview(descriptionLable)
        
        NSLayoutConstraint.activate([
            descriptionIconImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            descriptionIconImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 30),
            descriptionIconImageView.widthAnchor.constraint(equalToConstant: 16),
            
            descriptionLable.topAnchor.constraint(equalTo: descriptionIconImageView.topAnchor),
            descriptionLable.leadingAnchor.constraint(equalTo: descriptionIconImageView.trailingAnchor, constant: 10),
            descriptionLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    func fetchImage(from url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            return image
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    
    func fetchSpecies(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonSpecy = try JSONDecoder().decode(PokemonSpecy.self, from: data)
            self.pokemon?.specy = pokemonSpecy
        } catch {
            print(String(describing: error))
        }
        return
    }
}
