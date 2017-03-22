//
//  ColorButton.swift
//  CoreySalzer-Lab3
//
//  Created by Corey Salzer on 2/13/17.
//  Copyright © 2017 Corey Salzer. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ColorButton: UIButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
    }
}
