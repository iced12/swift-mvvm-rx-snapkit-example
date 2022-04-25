//
//  GitReposRepository.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift

protocol GitReposRepository {
    func fetchRepos(
        with topic: String,
        at page: Int
    ) -> Single<GitRepoResponse?>
}
