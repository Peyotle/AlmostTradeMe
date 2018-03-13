//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

class CategoryViewController: UIViewController {
    let categoryCellIdentifier = "categoryCell"
    let loadingCellIdentifier = "loadingCell"

    var tableView: UITableView { return self.view as! UITableView }
    weak var delegate: CategoryBrowserDelegate?
    private var nonEmptyCategories: [Category] { return model?.subcategories?.filter { $0.count != nil } ?? [] }
    private var model: Category?

    func setModel(_ model: Category) {
        self.model = model
        self.title = model.name
        self.tableView.reloadData()
    }
    
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
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryCellIdentifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: loadingCellIdentifier)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isMovingFromParentViewController else { return }
        delegate?.movingBack()
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard nonEmptyCategories.count > 0 else { return }
        let selectedCategory = nonEmptyCategories[indexPath.row]
        delegate?.moveToCategory(selectedCategory)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (self.model != nil) else {
            return 1
        }
        return nonEmptyCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard (self.model != nil) else {
            return tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier)!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) as! CategoryTableViewCell
        let category = nonEmptyCategories[indexPath.row]
        cell.setup(with: category)
        return cell
    }
}
