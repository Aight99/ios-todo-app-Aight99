//
//  Assets.swift
//  ToDo
//
//  Created by ios_developer on 23.06.2023.
//

import UIKit

enum Fonts {
    static let largeTitle: UIFont = .systemFont(ofSize: 38, weight: .bold)
    static let title: UIFont = .systemFont(ofSize: 20, weight: .semibold)
    static let headline: UIFont = .systemFont(ofSize: 17, weight: .semibold)
    static let body: UIFont = .systemFont(ofSize: 17)
    static let subhead: UIFont = .systemFont(ofSize: 15)
    static let footnote: UIFont = .systemFont(ofSize: 13, weight: .semibold)

    enum Style {
        case largeTitle
        case title
        case headline
        case body
        case subhead
        case footnote
    }

    static func getAttributedString(style: Style, text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()

        let pair: (CGFloat, UIFont) = {
            switch style {
            case .largeTitle: return (0.46, Fonts.largeTitle)
            case .body: return (0.24, Fonts.body)
            case .footnote: return (0.22, Fonts.footnote)
            case .headline: return (0.22, Fonts.headline)
            case .subhead: return (0.20, Fonts.subhead)
            case .title: return (0.18, Fonts.title)
            }
        }()
        let lineHeight = pair.0
        let font = pair.1

        paragraphStyle.lineSpacing = lineHeight
        let string = NSMutableAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: font
            ]
        )
        return string
    }
}

enum Colors {
    static let Default: UIColor = .black

    enum Main {
        static let red: UIColor = UIColor(named: "Red") ?? Colors.Default
        static let green: UIColor = UIColor(named: "Green") ?? Colors.Default
        static let blue: UIColor = UIColor(named: "Blue") ?? Colors.Default
        static let gray: UIColor = UIColor(named: "Gray") ?? Colors.Default
        static let grayLight: UIColor = UIColor(named: "Gray Light") ?? Colors.Default
        static let white: UIColor = UIColor(named: "White") ?? Colors.Default
    }

    enum Label {
        static let disable: UIColor = UIColor(named: "Label Disable") ?? Colors.Default
        static let primary: UIColor = UIColor(named: "Label Primary") ?? Colors.Default
        static let secondary: UIColor = UIColor(named: "Label Secondary") ?? Colors.Default
        static let tertiary: UIColor = UIColor(named: "Label Tertiary") ?? Colors.Default
    }

    enum Back {
        static let iOSPrimary: UIColor = UIColor(named: "Back iOS Primary") ?? Colors.Default
        static let primary: UIColor = UIColor(named: "Back Primary") ?? Colors.Default
        static let secondary: UIColor = UIColor(named: "Back Secondary") ?? Colors.Default
        static let elevated: UIColor = UIColor(named: "Back Elevated") ?? Colors.Default
    }

    enum Support {
        static let separator: UIColor = UIColor(named: "Support Separator") ?? Colors.Default
        static let overlay: UIColor = UIColor(named: "Support Overlay") ?? Colors.Default
        static let navBarBlur: UIColor = UIColor(named: "Support NavBar Blur") ?? Colors.Default
    }
}

enum SfSymbolNames {
    static let circle = "circlebadge"
    static let circleChecked = "checkmark.circle.fill"
    static let calendar = "calendar"
    static let trash = "trash.fill"
    static let chevronForward = "chevron.forward"
    static let plus = "plus"

}
