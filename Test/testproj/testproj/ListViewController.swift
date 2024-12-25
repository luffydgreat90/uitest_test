//
//  ViewController.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import UIKit

final class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: ViewModel
    private let didSelectCharacter: (Character) -> Void

    init?(coder: NSCoder, 
          viewModel: ViewModel,
          didSelectCharacter: @escaping (Character) -> Void) {
        self.viewModel = viewModel
        self.didSelectCharacter = didSelectCharacter
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Rick and Morty"
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getCharacters), for: .valueChanged)

        tableView.refreshControl?.beginRefreshing()
        getCharacters()
    }

    @objc private func getCharacters() {
        viewModel.getCharacters { result in
            DispatchQueue.main.async {  [weak self] in
                switch result {
                    case .success:
                        self?.tableView.reloadData()
                        self?.tableView.refreshControl?.endRefreshing()
                    case .failure:
                        break
                    }
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestCell
        let character = viewModel.characters[indexPath.row]
        cell.titleLabel.text = character.name

        Task {
            await viewModel.imageStore.getImage(url: character.image) { [weak cell] result in
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
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCharacter(viewModel.characters[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
