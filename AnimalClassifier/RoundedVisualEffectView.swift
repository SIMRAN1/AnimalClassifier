//
//  RoundedVisualEffectView.swift
//  AnimalClassifier
//
//  Created by Apple on 07/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RoundedVisualEffectView: UIVisualEffectView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
        self.clipsToBounds = true
        
    }

}
