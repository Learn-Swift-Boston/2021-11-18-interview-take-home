//
//  RepoListViewModel.swift
//  TakeHome
//
//  Created by Zev Eisenberg on 11/18/21.
//

import Foundation
import UsefulDecode

final class RepoListViewModel: ObservableObject {

    enum State {
        case loading
        case loaded(org: Org, repos: [Repo])
    }

    @Published var state: State = .loading

    @MainActor func loadRepos() async {
        state = .loading
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
            self.state = .loaded(org: org, repos: sortedRepos)
        } catch {
            print("error loading: \(error)")
        }
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
