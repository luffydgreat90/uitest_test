//
//  TestCell.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import UIKit

final class TestCell: UITableViewCell {
    weak var task: URLSessionTask?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
