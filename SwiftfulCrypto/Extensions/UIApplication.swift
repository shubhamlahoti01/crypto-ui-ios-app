//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 21/09/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
