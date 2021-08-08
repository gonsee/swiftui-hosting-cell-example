//
//  ItemCell.swift
//  SwiftUIHostingCellExample
//
//  Created by Shingo Sato on 2021/08/08.
//

import SwiftUI

final class ItemCell: HostingCell<ItemView> {

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = false
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 3

        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 16
    }

}

struct ItemView: HostingCellContent {

    typealias Dependency = ViewModel

    struct ViewModel {
        var text: String
    }

    var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.text)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
        .padding(12)
    }

}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(.init(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."))
            .previewLayout(.fixed(width: 320, height: 240))
    }
}
