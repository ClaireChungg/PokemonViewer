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
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let networkManager: NetworkManager = .shared
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNameAndIdLabels()
        setupImageView()
        setupActivityIndicator()
        
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemon?.sprite?.id ?? 1)"
        Task {
            activityIndicator.startAnimating()
            self.pokemon?.specy = await networkManager.fetchSpecy(from: urlString)
            setupDescriptionLable()
            activityIndicator.stopAnimating()
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
            thumbnailImageView.image = await networkManager.fetchImage(from: pokemon?.sprite?.imageUrl)
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
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
