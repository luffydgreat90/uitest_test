//
//  ViewController.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: ViewModel

    init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension ViewController: UITableViewDataSource {
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
