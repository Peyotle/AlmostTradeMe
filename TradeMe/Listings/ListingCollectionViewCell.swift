//
//  ListingCollectionViewCell.swift
//  TradeMe
//
//  Created by Oleg Chernyshenko on 11/03/18.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.addSubview(titleLabel)
    }

    func setup(with listing: SearchResult.Listing) {
        titleLabel.text = listing.title
        titleLabel.sizeToFit()
        titleLabel.center = self.contentView.center
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
