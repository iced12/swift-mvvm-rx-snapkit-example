//
//  ListViewCellViewModel.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxCocoa
import RxDataSources

struct ListViewCellModel: IdentifiableType {
    let identity: Int
    let titleText: Driver<String>
    let descriptionText: Driver<String>
    let repo: GitRepo

    init(repo: GitRepo) {
        self.repo = repo
        self.identity = repo.id
        self.titleText = .just(repo.full_name ?? "")
        self.descriptionText = .just(repo.description ?? "")
    }
}
