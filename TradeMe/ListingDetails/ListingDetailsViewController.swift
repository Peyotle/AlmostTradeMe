//  Created by Oleg Chernyshenko on 11/03/18.

import UIKit

class ListingDetailsViewController: UIViewController {
    var mainView: ListingDetailsView { return self.view as! ListingDetailsView }
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

    override func loadView() {
        self.view = ListingDetailsView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadListingDetails()
        self.view.backgroundColor = .white
        mainView.titleLabel.text = listing.title
        mainView.idLabel.text = "Listing #: \(listing.listingId)"
    }

    private func loadListingDetails() {
        listingLoader?.getListing(listing.listingId, completion: { [weak self] listing in
            guard let listing = listing else { return }
            self?.listingDetails = listing
            self?.updateDetails(listing)
        })
    }

    private func updateDetails(_ listingDetails: Listing) {
        if let photo = listingDetails.photos?.first {
            imageLoader?.loadImage(url: photo.value.large, completion: { [weak self] (image, error) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.mainView.imageView.image = image
                        self?.mainView.imageView.alpha = 1
                        self?.mainView.activityView.stopAnimating()
                        self?.mainView.layoutIfNeeded()
                    })
                }
            })
        } else {
            mainView.activityView.stopAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.mainView.imageView.alpha = 1
                self.mainView.imageView.image = UIImage(named: "no_photo")
            })
        }
    }
}
