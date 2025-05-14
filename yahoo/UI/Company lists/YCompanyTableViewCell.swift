//
//  YCompanyTableViewCell.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import UIKit

class YCompanyTableViewCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCompany(_ company: YCompany) {
        self.label.text = company.name
    }
    
    private func setup() {
        self.contentView.addSubview(self.label)
        let chevronImageView = UIImageView(image: UIImage(named: "chevron")?.withRenderingMode(.alwaysTemplate))
        chevronImageView.tintColor = .white
        self.accessoryView = chevronImageView
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        self.backgroundView = view
        self.accessoryType = .disclosureIndicator
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.09).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0).isActive = true

        //make breakable to prevent constraint errors when cell is first created and frame has not been laid out
        let trailing = self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0)
        trailing.priority = UILayoutPriority(999)
        trailing.isActive = true
        
        let bottom = self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0)
        bottom.priority = UILayoutPriority(999)
        bottom.isActive = true
    }
}
