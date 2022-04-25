//
//  FetchGitReposUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift

protocol FetchGitReposUseCase {
    func fetchRepos(
        with topic: String,
        at page: Int
    ) -> Single<GitRepoResponse?>
}

final class FetchGitReposUseCaseImpl: FetchGitReposUseCase {
    private let repository: GitReposRepository

    init(repository: GitReposRepository) {
        self.repository = repository
    }

    func fetchRepos(
        with topic: String,
        at page: Int
    ) -> Single<GitRepoResponse?> {
        repository
            .fetchRepos(with: topic, at: page)
            .catch { error in
                if let error = error as? RestClientError {
                    print(".failed:", error.description)
                }
                ///maybe map to something like an error with domain logic like DomainError?
                return .error(error)
            }
    }
}
