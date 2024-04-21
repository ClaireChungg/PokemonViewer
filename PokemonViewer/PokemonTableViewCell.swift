//
//  PokemonTableViewCell.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/19.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(thumbnailImageView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}
