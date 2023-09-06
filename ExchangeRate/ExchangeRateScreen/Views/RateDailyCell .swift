//
//  RateDailyCell .swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import UIKit

private enum Constants {
    static let leftOffset: CGFloat = 30
    static let rightOffset: CGFloat = 10
    static let verticalOffset: CGFloat = 8
    static let middleOffset: CGFloat = 60
}

final class RateDailyCell: UITableViewCell {
    
    // UI
    private lazy var dateLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = DefaultConstants.bodyFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rateLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = DefaultConstants.bodyFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        addSubview(dateLbl)
        addSubview(rateLbl)
        
        NSLayoutConstraint.activate([
            dateLbl.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalOffset),
            dateLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leftOffset),
            dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalOffset),
            rateLbl.leftAnchor.constraint(equalTo: dateLbl.rightAnchor, constant: Constants.middleOffset),
            rateLbl.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalOffset),
            rateLbl.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.rightOffset),
            rateLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalOffset),
        ])
    }
}

// MARK: - Configurable

extension RateDailyCell: Configurable {
    
    struct Model {
        let date: Date
        let price: Double
        
        init(from: DailyRateModel) {
            self.date = from.date
            self.price = from.price
        }
    }
    
    func configure(model: Model) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"    
        self.dateLbl.text = formatter.string(from: model.date)
        self.rateLbl.text = String(model.price)
    }
}
