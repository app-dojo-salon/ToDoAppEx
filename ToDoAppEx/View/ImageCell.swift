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
    @IBOutlet weak var remainDayLabel: UILabel!

    func configure(image: String, title: String, category: String,
                   startDate: String, endDate: String, status: Bool) {
		titleLabel.text = title
        categoryLabel.text = category

        setDate(startDate: startDate, endDate: endDate) { start, interval in
            startDateLabel.text = start
            remainDayLabel.text = "残り\(interval)日"
        }

        if status {
            titleImageView.image = UIImage(named: image)!
        }
        print(startDate)
        print(endDate)
	}

    private func setDate(startDate: String, endDate: String,
                         operation: (_ start: String, _ end: String) -> Void) {
        let start = String(startDate.prefix(10))
        let end = String(endDate.prefix(10))
        let interval = String(Date().getIntervalDate(start: start, end: end))
        operation(start, interval)
    }
}
