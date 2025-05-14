//
//  YCompanyDetailView.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import UIKit

class YCompanyDetailView: UIView {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let marketCapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.addArrangedSubview(self.nameLabel)
        stack.addArrangedSubview(self.symbolLabel)
        stack.addArrangedSubview(self.marketCapLabel)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.addSubview(self.stack)
        self.stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        self.stack.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(company: YCompany) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        
        self.symbolLabel.text = "Symbol: " + company.symbol
        self.nameLabel.text = "Name: " + company.name
        self.marketCapLabel.text = "Market Cap: " + (formatter.string(for: company.marketCap.value) ?? company.marketCap.formattedString)
    }
}
