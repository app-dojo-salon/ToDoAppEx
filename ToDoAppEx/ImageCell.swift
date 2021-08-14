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
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UIStackView!

    func configure(image: String, title: String, category: String,
                   startDate: String, endDate: String) {
		titleImageView.image = UIImage(named: image)!
		titleLabel.text = title
        categoryLabel.text = category
        print(startDate)
        print(endDate)
	}
}
