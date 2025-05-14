//
//  YSettingsView.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import UIKit

class YSettingsView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Company List Sort:", comment: "company list sort")
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let sortOrderSegment: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Name", "Symbol"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.addSubview(self.label)
        self.addSubview(self.sortOrderSegment)
        
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.sortOrderSegment.leadingAnchor, constant: 16.0).isActive = true
        self.label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0).isActive = true

        self.sortOrderSegment.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        self.sortOrderSegment.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
