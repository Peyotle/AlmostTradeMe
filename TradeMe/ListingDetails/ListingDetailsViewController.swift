//  Created by Oleg Chernyshenko on 11/03/18.


import UIKit

class ListingDetailsViewController: UIViewController {
    private var listing: SearchResult.Listing
    private var listingDetails: Listing?
    var listingLoader: ListingLoader?
    var imageLoader: ImageLoader?

    init(with listing: SearchResult.Listing) {
        self.listing = listing
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        listingLoader?.getListing(listing.listingId, completion: { [weak self] listing in
            guard let listing = listing else { return }
            self?.listingDetails = listing
            self?.updateDetails(listing)
        })
        self.setupViews()
    }

    private func updateDetails(_ listingDetails: Listing) {
        if let photo = listingDetails.photos?.first {
            imageLoader?.loadImage(url: photo.value.large, completion: { [weak self] (image, error) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.imageView.image = image
                        self?.imageView.alpha = 1
                        self?.activityView.stopAnimating()
                        self?.view.layoutIfNeeded()
                    })
                }
            })
        } else {
            imageView.alpha = 1
            imageView.image = UIImage(named: "no_photo")
        }
    }

    private func setupViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        scrollView.pinEdges(to: self.view)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(activityView)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(idLabel)

        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
//            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200.0)
            activityView.heightAnchor.constraint(equalToConstant: 200.0)
            ])

        titleLabel.text = listing.title
        idLabel.text = "Listing #: \(listing.listingId)"
        self.view.needsUpdateConstraints()
    }

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()

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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.isOpaque = false
        imageView.alpha = 0
        return imageView
    }()

    let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activity.startAnimating()
        activity.activityIndicatorViewStyle = .gray
        return activity
    }()
}
