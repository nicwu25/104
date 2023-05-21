//
//  ViewController.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<ViewModel.Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, AnyHashable>
    
    private let bannerVC = BannerViewController()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        view.register(AD1CollectionViewCell.self, forCellWithReuseIdentifier: AD1CollectionViewCell.reuseIdentifier)
        view.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.reuseIdentifier)
        view.register(JobCollectionViewCell.self, forCellWithReuseIdentifier: JobCollectionViewCell.reuseIdentifier)
        view.backgroundColor = .systemGray6
        view.contentInsetAdjustmentBehavior = .never
        view.refreshControl = refreshControl
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.addTarget(self, action: #selector(refreshJobList), for: .valueChanged)
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "搜尋公司、職稱..."
        view.backgroundImage = UIImage()
        view.searchTextField.backgroundColor = .white
        view.searchTextField.tintColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = ViewModel()
    
    private lazy var dataSource = makeDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        fetchJobList()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        collectionView.dataSource = dataSource
    }
    
    private func fetchJobList() {
        Task {
            do {
                try await viewModel.fetchJobList()
            } catch {
                showAlert(title: error.getNetworkErrorMessage())
            }
        }
    }
    
    @objc private func refreshJobList() {
        Task {
            do {
                refreshControl.beginRefreshing()
                try await viewModel.refreshJobList()
                refreshControl.endRefreshing()
            } catch {
                refreshControl.endRefreshing()
            }
        }
    }
    
    private func bind() {
        Publishers.CombineLatest4(viewModel.$bannerList,
                                  viewModel.$ad1List,
                                  viewModel.$selectedMenuItem,
                                  viewModel.$jobList)
            .receive(on: DispatchQueue.main)
            .map{ [unowned self] bannerList, ad1List, selectedMenuItem, jobList in
                let menuList = viewModel.menuItems.map{ MenuViewObject(item: $0, isSelected: $0 == selectedMenuItem)}
                return (bannerList, ad1List, menuList, jobList)
            }
            .sink { [unowned self] bannerList, ad1List, menuLsit, jobList in
                var snapshot = Snapshot()
                snapshot.appendSections(viewModel.sections)
                if let bannerList {
                    bannerVC.update(list: bannerList)
                }
                snapshot.appendItems(ad1List, toSection: .ad1)
                snapshot.appendItems(menuLsit, toSection: .menu)
                snapshot.appendItems(jobList, toSection: .job)
                dataSource.apply(snapshot, animatingDifferences: false)
            }.store(in: &cancellables)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        switch section {
        case .ad1:
            break
        case .menu:
            if let item = viewModel.getMenuItem(index: indexPath.row) {
                viewModel.selectedMenuItem = item
            }
        case .job:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) else { return }
        fetchJobList()
    }
}

extension ViewController {
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
            guard let visitable = item as? Visitable,
                  let cell = visitable.accept(visitor: CellConfiguratorVisitor(collectionView: collectionView, indexPath: indexPath)) else { return UICollectionViewCell() }
            return cell
        }
        let bannerHeaderRegistration = UICollectionView.SupplementaryRegistration
            <BannerCollectionViewHeader>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, string, indexPath in
                supplementaryView.add(childVC: bannerVC, toParent: self)
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: bannerHeaderRegistration,
                                                                  for: indexPath)
        }
        return dataSource
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { [unowned self] sectionIndex, layoutEnvironment in
            let snapshot = dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[sectionIndex]
            guard let visitable = snapshot.itemIdentifiers(inSection: section).first as? Visitable,
                  let layoutSection = visitable.accept(visitor: CollectionViewLayoutVisitor()) else { return nil }
            return layoutSection
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [getAdHeader()]
        configuration.contentInsetsReference = .none
        layout.configuration = configuration
        
        return layout
    }
    
    private func getAdHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(250))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true
        header.contentInsets = .zero
        return header
    }
}
