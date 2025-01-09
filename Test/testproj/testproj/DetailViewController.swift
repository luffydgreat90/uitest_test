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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let character: Character
    private let imageStore: ImageStore

    init?(coder: NSCoder, character: Character, imageStore: ImageStore) {
        self.character = character
        self.imageStore = imageStore
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        nameLabel.text = character.name
        statusLabel.text = character.status
        locationLabel.text = character.location.name

        Task {
            await imageStore.getImage(url: character.image, completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.imageView.image = UIImage(data: data)
                    case .failure:
                        break
                    }
                }
            })
        }

    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        return cell
    }
}
