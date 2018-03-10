//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

class ListingsViewController: UIViewController {
    let listingCellIdentifier = "listingCell"
    
    var collectionView: UICollectionView { return self.view as! UICollectionView }
    var listings = [SearchResult.Listing]()

    override func loadView() {
        self.view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        print("Listings: \(listings)")
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: listingCellIdentifier)
    }

    let layout: UICollectionViewFlowLayout = {
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
        print(listing)
    }
}

extension ListingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingCellIdentifier, for: indexPath)
        setupCell(cell, indexPath)
        return cell
    }

    func setupCell(_ cell: UICollectionViewCell, _ indexPath: IndexPath) {
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.borderWidth = 1.0
        let label = UILabel()
        label.text = listings[indexPath.row].title
        label.sizeToFit()
        cell.contentView.addSubview(label)
        label.center = cell.contentView.center
    }

}