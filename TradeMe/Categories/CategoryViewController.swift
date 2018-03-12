//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

class CategoryViewController: UIViewController {
    let categoryCellIdentifier = "categoryCell"
    let loadingCellIdentifier = "loadingCell"

    var tableView: UITableView { return self.view as! UITableView }
    weak var delegate: CategoryBrowserDelegate?
    var categories = [SearchResult.Category]()
    private var model: CategoryModel?

    func setModel(_ model: CategoryModel) {
        self.model = model
        self.categories = model.categories
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
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            if let model = model {
                delegate?.movingBack(to: model.parentCategoryId)
            }
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        delegate?.showCategory(selectedCategory)
//        if selectedCategory.hasSubcategory {
//            delegate?.moveToCategory(id: selectedCategory.categoryId, name: selectedCategory.name)
//        } else {
//            delegate?.updateCategory(id: selectedCategory.categoryId, name: selectedCategory.name)
//        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (self.model != nil) else {
            return 1
        }
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard (self.model != nil) else {
            return tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier)!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) as! CategoryTableViewCell
        let category = categories[indexPath.row]
        cell.setup(with: category)
        return cell
    }
}
