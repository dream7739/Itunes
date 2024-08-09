//
//  UIButton.Configuration+.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import UIKit

extension UIButton.Configuration {
    static var download: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        return configuration
    }
}


