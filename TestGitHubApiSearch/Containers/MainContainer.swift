//
//  MainContainer.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation

/**
 Usually i would use some kind of DI lib (like Swinject) to instantiate objects and manage their scopes ,
 But to keep this project simple and also to not use too many external libs I will use containers to manage the scopes of objects
 */
final class MainContainer {
    /**
    restClient, repository should be created once per container (module) and shared among objects of the same container,
    or in case of this project as a singleton for the whole project
    */
    private static let restClient: RestClient = RestClientImpl()
    private static let userRequestProvider: RequestProvider = RequestProviderImpl()
    private static var userRepository: GitReposRepository = GitReposRepositoryImpl(
        restClient: restClient,
        requestProvider: userRequestProvider
    )
}

// MARK - List View

extension MainContainer {
    static func makeUserListViewModel() -> ListViewModel {
        /** use cases are created everytime it is needed */
        let fetchGitReposUseCase = FetchGitReposUseCaseImpl(repository: userRepository)
        let filterGitReposUseCase = FilterGitReposUseCaseImpl()
        return ListViewModel(
            fetchGitReposUseCase: fetchGitReposUseCase,
            filterGitReposUseCase: filterGitReposUseCase
        )
    }

    static func makeUserListView(with viewModel: ListViewModel) -> ListViewController {
        return ListViewController(
            mainView: ListView(),
            viewModel: viewModel
        )
    }
}
