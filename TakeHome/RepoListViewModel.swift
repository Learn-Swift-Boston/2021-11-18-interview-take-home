//
//  RepoListViewModel.swift
//  TakeHome
//
//  Created by Zev Eisenberg on 11/18/21.
//

import Foundation
import UsefulDecode

final class RepoListViewModel: ObservableObject {

    @Published var data: (org: Org, repos: [Repo])?

    var allRepos: [Repo] = []

    @Published var searchString = ""

    @MainActor func loadRepos() async {
        let reposRequest = request(forEndpoint: "orgs/learn-swift-boston/repos")
        let orgRequest = request(forEndpoint: "orgs/learn-swift-boston")
        do {
            async let reposResult = try URLSession.shared.data(for: reposRequest, delegate: nil)
            async let orgResult = try URLSession.shared.data(for: orgRequest, delegate: nil)
            let repos = try await JSONDecoder.gitHub.decodeWithBetterErrors([Repo].self, from: reposResult.0)
            let org = try await JSONDecoder.gitHub.decodeWithBetterErrors(Org.self, from: orgResult.0)
            let sortedRepos = repos.sorted(by: { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            })
            allRepos = sortedRepos
            data = (org: org, repos: allRepos)
            performSearch()
        } catch {
            print("error loading: \(error)")
        }
    }

    func performSearch() {
        guard !allRepos.isEmpty else { return }
        guard !searchString.isEmpty else { data?.repos = allRepos; return }
        data?.repos = allRepos.filter { $0.name.lowercased().contains(searchString.lowercased()) }
    }
}

private extension RepoListViewModel {
    func request(forEndpoint endpoint: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/\(endpoint)")!)
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3+json",
        ]
        return request
    }
}
