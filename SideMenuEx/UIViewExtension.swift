//
//  UIViewExtension.swift
//  SideMenuEx
//
//  Created by onnoffcompany on 2022/06/09.
//

import Foundation
import UIKit

extension UIView {
    
    public func setOnTouchListener(_ target: Any?, action: Selector) {

        self.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(guestureRecognizer)
    }
    
}
