//
//  ViewController.swift
//  SwiftUIHostingCellExample
//
//  Created by Shingo Sato on 2021/08/08.
//

import UIKit

final class ViewController: UIViewController {

    enum Section: Int {
        case first
        case second
    }

    enum Item: Hashable {
        case item(text: String)
    }

    private let data = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nNullam condimentum ante quis purus sagittis finibus.",
        "Aliquam vel libero vel metus consectetur laoreet.",
        "Nulla vehicula nibh et est laoreet accumsan.\nVestibulum aliquet diam sed ornare iaculis.",
        "Ut fringilla massa ac arcu gravida, sit amet hendrerit est iaculis.",
        "Vestibulum euismod purus quis justo consequat imperdiet.",
        "Vestibulum sed libero ultrices, ultricies magna non, pretium mi.",
        "Etiam ut metus eu lectus cursus luctus in et ligula.",
        "Nullam a dui vitae nisi cursus rhoncus.",
    ]

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    private lazy var layout = UICollectionViewCompositionalLayout { section, _ in
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .first:
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100) // 高さは可変
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            section.interGroupSpacing = 8
            return section
        case .second:
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .absolute(160),
                heightDimension: .absolute(240)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous // 要素を横スクロールさせる
            section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            section.interGroupSpacing = 8
            return section
        }
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let cellRegistration = UICollectionView.CellRegistration<ItemCell, Item> { [weak self] cell, indexPath, item in
            guard let self = self,
                  case let .item(text) = item else { return }
            cell.configure(.init(text: text), parent: self)
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .item:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
        return dataSource
    }()

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(data[0..<3].map({ .item(text: $0) }), toSection: .first)
        snapshot.appendItems(data[3..<8].map({ .item(text: $0) }), toSection: .second)
        dataSource.apply(snapshot)
    }

}
