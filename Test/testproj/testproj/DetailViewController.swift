//
//  DetailViewController.swift
//  testproj
//
//  Created by Marlon Von Ansale on 25/12/2024.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let character: Character
    
    init?(coder: NSCoder, character: Character) {
        self.character = character
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        nameLabel.text = character.name
        statusLabel.text = character.status
    }
}
