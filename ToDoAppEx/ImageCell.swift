//
//  ImageCell.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2021/03/23.
//

import UIKit

final class ImageCell: UITableViewCell {

	@IBOutlet private weak var titleImageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!

	func configure(image: String, title: String) {
		titleImageView.image = UIImage(named: image)!
		titleLabel.text = title
	}
}
