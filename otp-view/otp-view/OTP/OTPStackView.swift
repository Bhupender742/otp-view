//
//  OTPStackView.swift
//  otp-view
//
//  Created by Bhupender Rawat on 12/08/23.
//

import UIKit

protocol OTPDelegate: AnyObject {
    func printOTP()
}

class OTPStackView: UIStackView {
    private let numberOfFields: Int
    private let textColor: UIColor
    private let textFont: UIFont
    private let borderColor: UIColor
    private let borderWidth: CGFloat
    private let secureText: Bool
    private let maskedChar: Character
    private let cornerRadius: CGFloat
    private var txtFields: [OTPTextField] = []
    var delegate: OTPDelegate?

    init(numberOfFields: Int, textFont: UIFont = .systemFont(ofSize: 14), textColor: UIColor = .black,
         borderColor: UIColor = .black, borderWidth: CGFloat = 2, secureText: Bool = false,
         maskedChar: Character = "*", spacing: CGFloat = 8, cornerRadius: CGFloat = 0) {
        self.numberOfFields = numberOfFields
        self.textColor = textColor
        self.textFont = textFont
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.secureText = secureText
        self.maskedChar = maskedChar
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        self.spacing = spacing
        setupStackView()
        addOTPFields()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension OTPStackView {
    func setupStackView() {
        contentMode = .center
        backgroundColor = .clear
        distribution = .fillEqually
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addOTPFields() {
        for index in 0..<numberOfFields {
            let txtField = OTPTextField()
            setupTextField(at: index, for: txtField)
            txtFields.append(txtField)
        }
        txtFields[0].becomeFirstResponder()
    }

    func setupTextField(at index: Int, for textField: OTPTextField) {
        /// Adding a marker to previous field
        index != 0 ? (textField.previousTextField = txtFields[index-1]) : (textField.previousTextField = nil)
        /// Adding a marker to next field for the field at index-1
        index != 0 ? (txtFields[index-1].nextTextField = textField) : ()

        addArrangedSubview(textField)
        textField.delegate = self
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.font = textFont
        textField.textColor = textColor
        textField.tintColor = textColor
        textField.backgroundColor = .white
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = borderWidth
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
        textField.inputAssistantItem.trailingBarButtonGroups.removeAll()

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalTo: heightAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func maskTxt(for textField: UITextField) {
        guard secureText else { return }
        textField.text = String(self.maskedChar)
    }
}

// MARK: - Helper Methods
extension OTPStackView {
    func getOTP() -> String {
        var otp = ""
        txtFields.forEach {
            otp += $0.otp
        }
        return otp
    }

    func addShadowToTxtFields(withOffset offset: CGSize, with color: UIColor,
                              withRadius radius: CGFloat, withOpacity opacity: Float) {
        txtFields.forEach { txtField in
            txtField.layer.shadowOffset = offset
            txtField.layer.shadowColor = color.cgColor
            txtField.layer.shadowRadius = radius
            txtField.layer.shadowOpacity = opacity
        }
    }

    func reset() {
        txtFields.forEach {
            $0.otp = ""
        }
    }
}

// MARK: - UITextField Delegate
extension OTPStackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let txtField = textField as? OTPTextField else {
            return false
        }
        txtField.nextTextField?.becomeFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let txtField = textField as? OTPTextField,
              let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        // Deleting the characters
        if updatedText.isEmpty {
            txtField.otp = updatedText
            txtField.previousTextField?.becomeFirstResponder()
            return false
        }

        if text.count == 0 {
            txtField.otp = updatedText
            maskTxt(for: txtField)
            return false
        }

        if let nextTxtField = txtField.nextTextField, let updatedTxt = updatedText.last {
            nextTxtField.otp = "\(updatedTxt)"
            nextTxtField.becomeFirstResponder()
            maskTxt(for: nextTxtField)
            return false
        }

        txtField.resignFirstResponder()
        delegate?.printOTP()
        return false
    }
}
