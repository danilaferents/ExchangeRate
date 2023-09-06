//
//  LastUpdateView.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import UIKit

private enum Constants {
    static let datLblVerticalOffset: CGFloat = 8
    static let datLblHorisontalOffset: CGFloat = 5
}

final class LastUpdateView: UIView {
    
    private lazy var dateLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = DefaultConstants.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        addSubview(dateLbl)
        NSLayoutConstraint.activate([
            dateLbl.topAnchor.constraint(equalTo: topAnchor, constant: Constants.datLblVerticalOffset),
            dateLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.datLblHorisontalOffset),
            dateLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.datLblHorisontalOffset),
            dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.datLblVerticalOffset)
        ])
    }
}

// MARK: - Configurable

extension LastUpdateView: Configurable {
    
    func configure(model: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YY, MMM d, hh:mm"
        self.dateLbl.text = formatter.string(from: model)
    }
}
