//
//  HostingCell.swift
//  SwiftUIHostingCellExample
//
//  Created by Shingo Sato on 2021/08/08.
//

import SwiftUI

/// HostingCellのContentになるViewが準拠するプロトコル
protocol HostingCellContent: View {
    associatedtype Dependency
    init(_ dependency: Dependency)
}

class HostingCell<Content: HostingCellContent>: UICollectionViewCell {

    private let hostingController = UIHostingController<Content?>(rootView: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ dependency: Content.Dependency, parent: UIViewController) {
        hostingController.rootView = Content(dependency)
        hostingController.view.invalidateIntrinsicContentSize()

        guard hostingController.parent == nil else { return }
        // 以下は初回のみ実行
        parent.addChild(hostingController)
        contentView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        hostingController.didMove(toParent: parent)
    }

}
