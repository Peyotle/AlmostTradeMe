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
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 10,
                                           bottom: 20,
                                           right: 10)
        return layout
    }()

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ListingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listing = listings[indexPath.row]
        delegate?.showListing(listing)
    }
}

extension ListingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingCellIdentifier,
                                                      for: indexPath) as! ListingCollectionViewCell
        let listing = listings[indexPath.row]
        cell.setup(with: listing)

        if let url = listing.pictureHref {
            imageLoader?.loadImage(url: url, completion: { (image, error) in
                DispatchQueue.main.async {
                    guard error == nil else {
                        cell.image = UIImage(named: "no_photo")
                        return
                    }
                    if image != nil {
                        cell.image = image
                    }
                }
            })
        }
        return cell
    }
}

extension ListingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeInsets = view.safeAreaInsets.left + view.safeAreaInsets.right
        let contentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let inset = layout.sectionInset
        let viewWithoutInsets = view.bounds.size.width - inset.left - inset.right - contentInsets - safeInsets
        let numberOfCells = max(floor(viewWithoutInsets / 250.0), 1)
        let sideLength = viewWithoutInsets / numberOfCells - inset.left / 2
        return CGSize(width: sideLength, height: sideLength)
    }

    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        collectionView.collectionViewLayout.invalidateLayout()
        return proposedContentOffset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
