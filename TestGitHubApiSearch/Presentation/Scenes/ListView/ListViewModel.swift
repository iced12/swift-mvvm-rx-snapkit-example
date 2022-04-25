//
//  ListViewModel.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift

enum ListViewModelOutput {
    case selected(GitRepo)
}

protocol ListViewModelCoordinating {
    var output: Observable<ListViewModelOutput> { get }
}

final class ListViewModel: ListViewModelCoordinating {
    typealias Section = SectionModel<UUID, ListViewCellModel>

    lazy var output: Observable<ListViewModelOutput> = Observable.merge(
        modelSelected.map { .selected($0.repo) }
    )

    let modelSelected = PublishRelay<ListViewCellModel>()
    let searchedText = PublishRelay<String?>()

    lazy var dataSource: Driver<[Section]> = filteredRepos
        .map { $0.map(ListViewCellModel.init) }
        .map { [Section(model: UUID(), items: $0)] }

    // MARK - Private

    private lazy var gitRepos = fetchGitReposUseCase
        .fetchRepos(with: Const.swiftTopic, at: 1)
        .map { $0?.items }
        .asDriver(onErrorJustReturn: nil)
        .startWith(nil)

    private lazy var filteredRepos = Driver.combineLatest(
        gitRepos.compactMap { $0 },
        searchedText.asDriver(onErrorJustReturn: nil)
    )
        .flatMapLatest { [filterGitReposUseCase] repos, searchedText -> Driver<[GitRepo]> in
            filterGitReposUseCase
                .filter(repos: repos, for: searchedText, by: \.full_name)
                .asDriver(onErrorJustReturn: [])
        }

    private let fetchAction = PublishRelay<Void>()
    private let fetchGitReposUseCase: FetchGitReposUseCase
    private let filterGitReposUseCase: FilterGitReposUseCase

    init(
        fetchGitReposUseCase: FetchGitReposUseCase,
        filterGitReposUseCase: FilterGitReposUseCase
    ) {
        self.fetchGitReposUseCase = fetchGitReposUseCase
        self.filterGitReposUseCase = filterGitReposUseCase
    }
}

private enum Const {
    static let swiftTopic = "swift"
}
