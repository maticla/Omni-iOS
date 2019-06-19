//
//  Cell.swift
//  Omni-iOS
//
//  Created by Matic on 19/06/2019.
//  Copyright © 2019 Matic. All rights reserved.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    var name: String? {
        didSet {
            guard let really = name as String? else { return }
            teamLabel.text = really
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .orange
        
        self.addSubview(teamLabel)
        
        teamLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 150)
        teamLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        teamLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    }
    
    let teamLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
