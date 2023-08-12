//
//  OTPTextField.swift
//  otp-view
//
//  Created by Bhupender Rawat on 12/08/23.
//

import UIKit

final class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?

    var otp: String = "" {
        didSet {
            updateTxt()
        }
    }

    override public func deleteBackward() {
        otp = ""
        previousTextField?.becomeFirstResponder()
    }
}

// MARK: - Private Methods
private extension OTPTextField {
    func updateTxt() {
        text = otp
    }
}
