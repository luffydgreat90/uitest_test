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
    private let urlClient: URLClient
    private var urlTaskImage: URLSessionTask?
    private var urlTaskLocation: URLSessionTask?
    private let dispatch = DispatchQueue(label: "character")
    private var residents: [Character] = []
    private let didSelectCharacter: (Character) -> ()
    init?(coder: NSCoder, character: Character, imageStore: ImageStore, urlClient: URLClient, didSelectCharacter: @escaping (Character) -> ()) {
        self.character = character
        self.imageStore = imageStore
        self.urlClient = urlClient
        self.didSelectCharacter = didSelectCharacter
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
            await getImage()
        }

        getLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        urlTaskImage?.cancel()
        urlTaskLocation?.cancel()
    }

    private func getImage() async {
        urlTaskImage = await imageStore.getImage(url: character.image, completion: { [weak self] result in
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

    private func getLocation() {
        urlTaskLocation = urlClient.getURL(url: character.location.url, complete: { [weak self] (result: Result<LocationDetail, Error>) in
            switch result {
            case .success(let location):
                self?.getLocationCharacters(location: location)
            case .failure:
                break
            }
        })
    }

    private func getLocationCharacters(location: LocationDetail) {
        let dispatchGroup = DispatchGroup()
        location.residents.forEach { url in
            dispatchGroup.enter()
            let _ = urlClient.getURL(url: url) {  [weak self] (result: Result<Character, Error>) in
                switch result {
                case .success(let character):
                    self?.dispatch.sync {
                        self?.residents.append(character)
                        dispatchGroup.leave()
                    }
                case .failure:
                    dispatchGroup.leave()
                    break
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return residents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        let character = residents[indexPath.row]
        cell.lblCharacter.text = character.name

        Task {
            await imageStore.getImage(url: character.image) { [weak cell] result in
                DispatchQueue.main.async { [weak cell] in
                    switch result {
                    case .success(let data):
                        cell?.imgView?.image = UIImage(data: data)
                    case .failure:
                        break
                    }
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = residents[indexPath.row]

        didSelectCharacter(character)
    }
}
