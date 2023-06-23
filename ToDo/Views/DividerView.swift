//
//  DividerView.swift
//  ToDo
//
//  Created by ios_developer on 24.06.2023.
//

import UIKit

class DividerView: UIView {

    let height: CGFloat

    init(height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
        backgroundColor = Colors.Support.separator

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
        ])
    }

    required init(coder: NSCoder) {
        fatalError("Interface Builder is not supported")
    }

}
