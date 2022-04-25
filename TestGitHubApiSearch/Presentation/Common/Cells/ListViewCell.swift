//
//  ListViewCell.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import UIKit

final class ListViewCell: UITableViewCell {
    private let cellView = ListViewCellView()

    required init?(coder aDecoder: NSCoder) {
        fatalError(#file)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupCellView()
    }
}

extension ListViewCell {
    func bind(viewModel: ListViewCellModel) {
        cellView.bind(viewModel)
    }
}

private extension ListViewCell {
    func setupCellView() {
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
