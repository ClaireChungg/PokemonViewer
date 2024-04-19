//
//  PokemonTableViewCell.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/19.
//

import UIKit
import Combine

class PokemonTableViewCell: UITableViewCell {
    var url: URL? {
        didSet {
            if let url = url {
                fetchDetailData(from: url)
            }
        }
    }
    
    let cellImageView = UIImageView()
    let nameLabel = UILabel()
    var cellShouldUpdate: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cellImageView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func fetchDetailData(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonSprite.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { pokemonSprite in
                guard let imageUrl = pokemonSprite.imageUrl else { return }
                self.fetchAndSetImage(from: imageUrl)
            })
            .store(in: &cancellables)
    }
    
    private func fetchAndSetImage(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { data in
                self.cellImageView.image = UIImage(data: data)
                self.cellShouldUpdate?()
            })
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
}
