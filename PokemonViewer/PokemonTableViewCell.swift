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
    var cellShouldUpdate: (() -> Void)?
    private let imageCache = NSCache<NSURL, UIImage>()
    private var imageFetchTask: Task<Void, Never>?
    
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
    
    func setupContent(_ name: String, _ imageUrl: URL?) {
        self.nameLabel.text = name
        imageFetchTask = Task {
            self.thumbnailImageView.image = await self.fetchImage(from: imageUrl)
        }
    }
    
    func fetchImage(from url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        do {
            if let image = imageCache.object(forKey: url as NSURL) {
                self.cellShouldUpdate?()
                return image
            } else {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return nil }
                self.imageCache.setObject(image, forKey: url as NSURL)
                self.cellShouldUpdate?()
                return image
            }
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageFetchTask?.cancel()
        thumbnailImageView.image = nil
    }
}
