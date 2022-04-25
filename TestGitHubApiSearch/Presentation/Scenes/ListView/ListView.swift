//
//  ListView.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ListView: UIView {
    typealias Section = ListViewModel.Section

    private let disposeBag = DisposeBag()

    @UsesAutoLayout
    private var inputText: UITextField = {
        let input = UITextField()
        input.placeholder = "Search name"
        input.borderStyle = .roundedRect
        return input
    }()

    @UsesAutoLayout
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    lazy var dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: Self.configureCell)

    override func didMoveToSuperview() {
        backgroundColor = .white
        setupTableView()

        addSubviews()
        layoutInputText()
        layoutTableView()
    }

    func bind(_ viewModel: ListViewModel) {
        disposeBag.insert(
            inputText.rx.text.bind(to: viewModel.searchedText),
            viewModel.dataSource.drive(tableView.rx.items(dataSource: dataSource)),
            tableView.rx.modelSelected(ListViewCellModel.self)
                .bind(to: viewModel.modelSelected)
        )
    }

    func setFocus() {
        inputText.becomeFirstResponder()
    }
}
private extension ListView {
    func addSubviews() {
        addSubview(inputText)
        addSubview(tableView)
    }

    func setupTableView() {
        tableView.registerCell(ofType: ListViewCell.self)
    }
}

// MARK - TableView Datasource

private extension ListView {
    static func configureCell(
        dataSource: TableViewSectionedDataSource<Section>,
        tableView: UITableView,
        indexPath: IndexPath,
        model: ListViewCellModel
    ) -> UITableViewCell {
        let cell = tableView.getCell(ofType: ListViewCell.self)
        cell.bind(viewModel: model)
        return cell
    }
}

// MARK - Layout

private extension ListView {
    func layoutInputText() {
        inputText.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(inputText.snp.bottom).offset(20)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
