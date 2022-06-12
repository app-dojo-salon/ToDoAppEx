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
    @IBOutlet private weak var remainDayLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!

    func configure(image: String, title: String, category: String,
                   startDate: String, endDate: String, status: Bool) {
		titleLabel.text = title
        categoryLabel.text = category
        print(titleLabel.text ?? "")

        setDate(startDate: startDate, endDate: endDate) { end, interval in
            startDateLabel.text = "期限日: \(end)"
            if (interval > 0) {
                remainDayLabel.text = "残り\(interval)日"
                remainDayLabel.textColor = .black
            } else if (interval == 0) {
                remainDayLabel.text = "本日"
                remainDayLabel.textColor = .black
            } else {
                remainDayLabel.text = "期限切れ"
                remainDayLabel.textColor = .red
            }
        }

        if status {
            titleImageView.image = UIImage(named: "check")!
        } else {
            titleImageView.image = UIImage()
        }
        print(startDate)
        print(endDate)
	}

    // 開始日と終了日から残り日数を取得するメソッド
    private func setDate(startDate: String, endDate: String,
                         operation: (_ end: String, _ interval: Int) -> Void) {
        let today = Date()
        // 表示日がタスクの開始日より前かを判定する
        let isTodayBeforeStart = today.compareDate(targetDay: startDate)
        let start = isTodayBeforeStart ? today.toStringWithCurrentLocaleDay() :String(startDate.prefix(10))
        let end = String(endDate.prefix(10))

        let interval = Date().getIntervalDate(start: start, end: end)
        operation(end, interval)
    }
}
