//
//  ListViewController.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import UIKit

final class ListViewController: UIViewController {
    private let mainView: ListView
    private let viewModel: ListViewModel

    init(mainView: ListView, viewModel: ListViewModel) {
        self.mainView = mainView
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.bind(viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        mainView.setFocus()
    }
}
