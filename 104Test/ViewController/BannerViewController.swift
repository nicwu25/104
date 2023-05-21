//
//  ADViewController.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/17.
//

import UIKit
import Combine

class BannerViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        view.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier)
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let viewModel: BannerViewModel = BannerViewModel()
    
    private let countDownTime: TimeInterval = 1.0
    private lazy var timer = Timer.publish(every: countDownTime, on: .main, in: .common).autoconnect()
    private var timerCancellable: AnyCancellable?
    
    private var currentPage: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.$bannerList
            .compactMap{$0}
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] adList in
                if !adList.list.isEmpty, timerCancellable == nil {
                    startTimer()
                }
                pageControl.numberOfPages = adList.list.count
                collectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    func update(list: AdList) {
        viewModel.bannerList = list
    }
}

// MARK: - Timer
extension BannerViewController {
    
    func startTimer() {
        timerCancellable = timer
            .sink(receiveValue: { [unowned self] _ in
                changeAd()
            })
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
    }
    
    private func changeAd() {
        var indexPath = IndexPath()
        currentPage += 1
        if currentPage < viewModel.numberOfItemsAdList() {
            indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            currentPage = 0
            indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        pageControl.currentPage = currentPage
    }
}

extension BannerViewController: UICollectionViewDelegate {
}

extension BannerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsAdList()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.reuseIdentifier, for: indexPath) as! BannerCollectionViewCell
        cell.label.text = "\(indexPath.row)"
        if let banner = viewModel.getBannerItem(index: indexPath.row) {
            cell.imageView.sd_setImage(with: URL(string: banner.image))
        }
        return cell
    }
}

extension BannerViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
}

extension BannerViewController {
    
    private func getCollectionViewLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(1.0)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [unowned self] visibleItems, point, environment in
            let page = round(point.x / UIScreen.main.bounds.width)
            currentPage = Int(page)
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
        return layout
    }
}
