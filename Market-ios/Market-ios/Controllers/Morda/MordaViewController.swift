import UIKit

final class MordaViewController: UIViewController {
    
    private var items: [Item] = []
    private let refreshControl = UIRefreshControl()
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        updateItems()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateItems), for: .valueChanged)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "За покупками!"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    @objc private func updateItems() {
        ServiceManager.shared.fetchAllItems { [weak self] result in
            switch result {
            case let .success(items):
                self?.items = items
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            case .failure:
                self?.refreshControl.endRefreshing()
                print()
            }
        }
    }
}

extension MordaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        cell.setup(with: item)
        return cell
    }
    
}

extension MordaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: 0)

        return CGSize(width: width, height: 300.0)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return finalWidth - 5.0
    }
}

extension MordaViewController: UICollectionViewDelegate {
    
}
