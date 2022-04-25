//
//  GitRepoResponse.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation

struct GitRepoResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitRepo]
}
