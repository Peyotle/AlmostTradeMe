//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

class ListingsViewController: UIViewController {
    let listingCellIdentifier = "listingCell"
    var collectionView: UICollectionView { return self.view as! UICollectionView }
    var listings = [SearchResult.Listing]()
    var imageLoader: ImageLoader?
    weak var delegate: ListingBrowserDelegate?

    override func loadView() {
        self.view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListingCollectionViewCell.self, forCellWithReuseIdentifier: listingCellIdentifier)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
    }

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: insetLeft,
                                           bottom: 5.0,
                                           right: insetRight)
        let itemWidth = 50.0
        layout.itemSize = CGSize(width: 200.0, height: 200.0)
        return layout
    }()
}

extension ListingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listing = listings[indexPath.row]
        print(listing.title)
        delegate?.showListing(listing)
    }
}

extension ListingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingCellIdentifier,
                                                      for: indexPath) as! ListingCollectionViewCell
        let listing = listings[indexPath.row]
        cell.setup(with: listing)

        if let url = listing.pictureHref {
            imageLoader?.loadImage(url: url, completion: { (image, error) in
                DispatchQueue.main.async {
                    guard error == nil else {
                        print("Error: \(error)")
                        return
                    }
                    if image != nil {
                        cell.imageView.image = image
                    }
                }
            })
        }
        return cell
    }

}
