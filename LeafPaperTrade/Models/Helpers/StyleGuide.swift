//
//  StyleGuide.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

enum PriceMovement {
    case up, down
    
    var accentColor: UIColor {
        switch self {
        case .up:
            return .upAccentColor
        default:
            return .upAccentColor
        }
    }
}

enum BackgroundType {
    case light(priceMovement: PriceMovement)
    case dark(priceMovement: PriceMovement)
    
    var titleTextColor: UIColor {
        switch self {
        case .dark:
            return .lightTitleTextColor
        case .light:
            return .darkTitleTextColor
        }
    }
    
    var textTextColor: UIColor {
        switch self {
        case .dark:
            return .lightTextTextColor
        case .light:
            return .darkTextTextColor
        }
    }
    
    var linkTextColor: UIColor {
        switch self {
        case .dark(let movement), .light(let movement):
            return movement.accentColor
        }
    }
}

extension UIColor {
    static let upAccentColor: UIColor = UIColor(red: 3/255, green: 7/255, blue: 40/255, alpha: 0.74)
        
    static let mapleBlueColor: UIColor = UIColor(red: 104/255, green: 209/255, blue: 224/255, alpha: 1.0)
    
    static let lightTextTextColor: UIColor = .white
    static let darkTextTextColor: UIColor = .black
    
    static let lightTitleTextColor: UIColor = .gray
    static let darkTitleTextColor: UIColor = .gray
}

extension CGFloat {
    static let titleTextSize: CGFloat = 12.0
    static let textTextSize: CGFloat = 24.0
    static let linkTextSize: CGFloat = 12.0
}

extension UILabel {
    
    func configureTitleLabel(withText text: String) {
        configure(withText: text.uppercased(), size: .titleTextSize, alignment: .left, lines: 0, robotoWeight: .medium)
    }
    
    func configureTextLabel(withText text: String) {
        configure(withText: text, size: .textTextSize, alignment: .left, lines: 0, robotoWeight: .regular)
    }
    
    func configureLinkLabel(withText text: String) {
        configure(withText: text.uppercased(), size: .linkTextSize, alignment: .left, lines: 0, robotoWeight: .medium)
    }
    
    private func configure(withText newText: String,
                           size: CGFloat,
                           alignment: NSTextAlignment,
                           lines: Int,
                           robotoWeight: RobotoWeight) {
        text = newText
        font = UIFont(name: robotoWeight.rawValue, size: size)
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
    }
}

enum RobotoWeight: String {
    case thin = "Roboto-Thin"
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
    case bold = "Roboto-Bold"
}

