
import UIKit

class ItemsViewController: UIViewController {
    @IBOutlet private weak var itemsTableView: UITableView!
    
    private var items: [ItemInfo] = []
    private let estimatedRowHeightForItemTableView: CGFloat = 109
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        configureTableView()
        setItems()
    }
}

// MARK: - Private Method

extension ItemsViewController {
    private func setTitle() {
        self.title = ExpoStringLiteral.itemsTitle.text
    }
    
    private func configureTableView() {
        self.itemsTableView.dataSource = self
        self.itemsTableView.delegate = self
        self.itemsTableView.estimatedRowHeight = estimatedRowHeightForItemTableView
    }
    
    private func setItems() {
        do {
            self.items = try Parser.parsedItemsInfo()
        } catch let error {
            showAlert(message: error.localizedDescription)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ExpoStringLiteral.alertActionOK.text,
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableViewDataSource Method

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.identifier) as? ItemTableViewCell else {
            return ItemTableViewCell()
        }
        let item: ItemInfo = self.items[indexPath.row]
        itemCell.itemImageView.image = UIImage(named: "\(item.imageName)")
        itemCell.itemTitleLabel.text = item.name
        itemCell.itemDescriptionLabel.text = item.shortDescription
        itemCell.accessibilityHint = "\(item.name)??? ??????????????? ???????????????."
        
        return itemCell
    }
}

// MARK: - TableViewDelegate Method

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(
            identifier: ItemDetailViewController.identifier,
            creator: { coder in
                return ItemDetailViewController(coder: coder, data: self.items[indexPath.row])
            }) else {
                return
            }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
