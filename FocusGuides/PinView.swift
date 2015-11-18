//
//  PinView.swift
//  FocusGuides
//
//  Created by Guy on 9/13/15.
//  Copyright © 2015 Houzz. All rights reserved.
//

import UIKit

class PinView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        adjustsImageWhenAncestorFocused = true
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canBecomeFocused() -> Bool {
        return true
    }
}
