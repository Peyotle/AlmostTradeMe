//  Created by Oleg Chernyshenko on 11/03/18.

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func awakeFromNib() {
        print("Awake")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: idLabel.topAnchor, constant: -5),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),

            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            idLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            ])
        self.contentView.needsUpdateConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    func setup(with listing: SearchResult.Listing) {
        titleLabel.text = listing.title
        idLabel.text = "Id: \(listing.listingId)"
        if listing.pictureHref == nil {
            self.imageView.image = UIImage(named: "no_photo")
            self.contentView.layoutIfNeeded()
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
