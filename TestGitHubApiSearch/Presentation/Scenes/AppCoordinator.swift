//
//  AppCoordinator.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import UIKit
import RxSwift

final class AppCoordinator {
    private let disposeBag = DisposeBag()
    private let mainWindow: UIWindow?
    private var mainNavController: UINavigationController?

    init(window: UIWindow?) {
        self.mainWindow = window
        startCoordinator()
    }
}

private extension AppCoordinator {
    func startCoordinator() {
        let initialView = makeListView()
        mainNavController = UINavigationController(rootViewController: initialView)

        mainWindow?.rootViewController = mainNavController
        mainWindow?.makeKeyAndVisible()
    }
}

// MARK - List View Coordination

private extension AppCoordinator {
    func makeListView() -> ListViewController {
        let listViewModel = MainContainer.makeUserListViewModel()
        setupListViewCoordinating(with: listViewModel)

        return MainContainer.makeUserListView(with: listViewModel)
    }

    func setupListViewCoordinating(with viewModel: ListViewModelCoordinating) {
        viewModel.output
            .subscribe(
                onNext: { [weak self] output in
                    switch output {
                    case let .selected(repo):
                        self?.navigateTo(repo.html_url)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK - Webview Coordination

private extension AppCoordinator {
    func navigateTo(_ urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }

        UIApplication.shared.open(url)
    }
}
