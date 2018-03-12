//  Created by Oleg Chernyshenko on 12/03/18.

import UIKit

class ListingDetailsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        scrollView.addSubview(activityView)
        scrollView.pinEdges(to: self)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
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
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            activityView.heightAnchor.constraint(equalToConstant: 200.0),
            activityView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            ])
    }
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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
