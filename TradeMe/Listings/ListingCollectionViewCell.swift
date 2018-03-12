//  Created by Oleg Chernyshenko on 11/03/18.

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            self.animateImageAppearance(newValue)
        }
    }

    func animateImageAppearance(_ image: UIImage?) {
        if image != nil {
            self.imageView.isOpaque = false
            self.imageView.image = image
            activityView.stopAnimating()
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 1.0
            }, completion: { _ in
                self.imageView.isOpaque = true
            })
        } else {
            activityView.startAnimating()
        }
    }

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
        contentView.addSubview(activityView)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            activityView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            activityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
        self.image = nil
        self.contentView.bringSubview(toFront: activityView)
    }

    func setup(with listing: SearchResult.Listing) {
        titleLabel.text = listing.title
        idLabel.text = "Listing #: \(listing.listingId)"
        if listing.pictureHref == nil {
            self.image = UIImage(named: "no_photo")
            self.contentView.layoutIfNeeded()
        } else {
            activityView.startAnimating()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isOpaque = false
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activity.activityIndicatorViewStyle = .gray
        return activity
    }()
}
