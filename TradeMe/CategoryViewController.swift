//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

class CategoryViewController: UIViewController {
    let categoryCellIdentifier = "categoryCell"
    var tableView: UITableView { return self.view as! UITableView }
    weak var delegate: CategoryBrowserDelegate?

    var categories = [SearchResult.Category]()

    override func loadView() {
        self.view = UITableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: categoryCellIdentifier)
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        print("Selected category: \(selectedCategory)")
        pushViewController(for: selectedCategory.categoryId)
    }

    func pushViewController(for categoryId: Int) {
        delegate?.updateCategory(id: categoryId)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier)!
        setupCell(cell: cell, for: indexPath)
        return cell
    }

    func setupCell(cell: UITableViewCell, for indexPath: IndexPath) {
        let category = categories[indexPath.row]
        if category.count > 0 {
            cell.accessoryType = .disclosureIndicator

        }
        cell.textLabel?.text = category.name
    }
}
