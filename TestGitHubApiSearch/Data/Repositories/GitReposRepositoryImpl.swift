//
//  GitReposRepositoryImpl.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift

final class GitReposRepositoryImpl: GitReposRepository {
    private let restClient: RestClient
    private let requestProvider: RequestProvider

    init(
        restClient: RestClient,
        requestProvider: RequestProvider
    ) {
        self.restClient = restClient
        self.requestProvider = requestProvider
    }

    func fetchRepos(
        with topic: String,
        at page: Int
    ) -> Single<GitRepoResponse?> {
        let request = requestProvider.makeGetReposRequest(for: topic, at: page)

        return restClient.execute(request: request, with: GitRepoResponse.self)
    }
}
