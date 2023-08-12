//
//  ViewController.swift
//  otp-view
//
//  Created by Bhupender Rawat on 12/08/23.
//

import UIKit

class ViewController: UIViewController {
    private lazy var otpStackView: OTPStackView = {
        let otpStackView = OTPStackView(numberOfFields: 4, secureText: true,
                                        maskedChar: "\u{2022}", cornerRadius: 16)
        otpStackView.delegate = self
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        return otpStackView
    }()

    private lazy var otpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private Methods
private extension ViewController {
    func setupViews() {
        view.addSubview(otpStackView)
        view.addSubview(otpLabel)

        NSLayoutConstraint.activate([
            otpStackView.heightAnchor.constraint(equalToConstant: 72),
            otpStackView.widthAnchor.constraint(equalToConstant: 240),
            otpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            otpLabel.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 16),
            otpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - OTP Delegate
extension ViewController: OTPDelegate {
    func printOTP() {
        otpLabel.text = otpStackView.getOTP()
    }
}
