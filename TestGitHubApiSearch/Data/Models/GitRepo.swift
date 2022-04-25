//
//  GitRepo.swift
//  TestGitHubApiSearch
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation

struct GitRepo: Codable {
    let id: Int
    let name: String?
    let full_name: String?
    let html_url: String?
    let description: String?
}
