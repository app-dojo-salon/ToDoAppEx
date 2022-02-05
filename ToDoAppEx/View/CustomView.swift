//
//  CustomView.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2021/05/08.
//

import UIKit

class CustomView: UIView {

    private let colors: [UIColor] = [
            #colorLiteral(red: 0.1766420007, green: 0.7149296403, blue: 0.4880971909, alpha: 1),
            #colorLiteral(red: 0.878418088, green: 0.1176269576, blue: 0.3533530831, alpha: 1),
            #colorLiteral(red: 0.9235511422, green: 0.6978375316, blue: 0.183695972, alpha: 1),
    ]

    override func draw(_ rect: CGRect) {
        drawLine(rect)
    }

    private func drawLine(_ rect: CGRect) {
        let path = UIBezierPath()

        path.move(to: rect.midX, rect.minY)
        path.addLine(to: rect.minX, rect.midY)
        path.close()

        colors[0].setStroke()
        path.lineWidth = 3.0
        path.stroke()

        let path1 = UIBezierPath()

        path1.move(to: rect.maxX, rect.minY)
        path1.addLine(to: rect.minX, rect.maxY)
        path1.close()

        colors[1].setStroke()
        path1.lineWidth = 3.0
        path1.stroke()

        let path2 = UIBezierPath()

        path2.move(to: rect.maxX, rect.midY)
        path2.addLine(to: rect.midX, rect.maxY)
        path2.close()

        colors[2].setStroke()
        path2.lineWidth = 3.0
        path2.stroke()
    }
}

private extension UIBezierPath {
    func move(to x: CGFloat, _ y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }

    func addLine(to x: CGFloat, _ y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}
