//
//  Cell.swift
//  Omni-iOS
//
//  Created by Matic on 19/06/2019.
//  Copyright © 2019 Matic. All rights reserved.
//

import UIKit
import Cards

class TeamCell: UICollectionViewCell {
    
    var cardTitle: String? {
        didSet {
            guard let title = cardTitle as String? else { return }
            CryptoCard.title = title
        }
    }
    var cardItemTitle: String? {
        didSet {
            guard let itemTitle = cardItemTitle as String? else { return }
            CryptoCard.itemTitle = itemTitle
        }
    }
    var cardItemSubtitle: String? {
        didSet {
            guard let itemSubtitle = cardItemSubtitle as String? else { return }
            CryptoCard.itemSubtitle = itemSubtitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        //self.backgroundColor = .black
        
        /*
        self.addSubview(teamLabel)
        
        teamLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 150)
        teamLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        teamLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
         */
        
        self.addSubview(CryptoCard)
        CryptoCard.translatesAutoresizingMaskIntoConstraints = false
        CryptoCard.heightAnchor.constraint(equalToConstant: 300).isActive = true
        CryptoCard.widthAnchor.constraint(equalToConstant: 300).isActive = true
        CryptoCard.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        CryptoCard.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        CryptoCard.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        CryptoCard.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    let teamLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let CryptoCard: CardHighlight = {
        let card = CardHighlight()
        card.title = "Title"
        card.itemTitle = "itemTitle"
        card.itemSubtitle = "itemSubtitle"
        //card.icon = "?"
        //card.hasParallax = false
        return card
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
