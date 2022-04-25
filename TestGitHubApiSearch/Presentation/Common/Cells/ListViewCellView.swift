//
//  ListViewCellView.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

final class ListViewCellView: UIView {
    private let disposeBag = DisposeBag()
    
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        get { false }
        set {}
    }

    @UsesAutoLayout
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(18)
        return label
    }()

    @UsesAutoLayout
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(14)
        label.textColor = .darkGray
        return label
    }()

    override func didMoveToSuperview() {
        addSubviews()
        setupView()
    }

    func bind(_ viewModel: ListViewCellModel) {
        viewModel.titleText.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.descriptionText.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
    }
}

private extension ListViewCellView {
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }

    func setupView() {
        layoutTitleLabel()
        layoutDescriptionLabel()
    }
}

// MARK - Layout

private extension ListViewCellView {
    func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    func layoutDescriptionLabel() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
