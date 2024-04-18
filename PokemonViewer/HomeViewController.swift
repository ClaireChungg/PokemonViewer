//
//  ViewController.swift
//  PokemonViewer
//
//  Created by Claire Chung on 2024/4/17.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        
        welcomeText.font = UIFont.boldSystemFont(ofSize: 20)
    }
}
