//
//  FilterGitReposUseCase.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift

protocol FilterGitReposUseCase {
    func filter(repos: [GitRepo], for searchText: String?, by keyPath: KeyPath<GitRepo, String?>) -> Single<[GitRepo]>
}

struct FilterGitReposUseCaseImpl: FilterGitReposUseCase {
    func filter(repos: [GitRepo], for searchText: String?, by keyPath: KeyPath<GitRepo, String?>) -> Single<[GitRepo]> {
        guard let searchText = searchText else { return .just(repos) }
        guard !searchText.isEmpty else { return .just(repos) }

        let filtered = repos.filter {
            $0[keyPath: keyPath]?.lowercased().contains(searchText.lowercased()) ?? false
        }

        return .just(filtered)
    }
}
