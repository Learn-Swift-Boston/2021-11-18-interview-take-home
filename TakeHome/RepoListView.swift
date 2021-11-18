//
//  RepoListView.swift
//  TakeHome
//
//  Created by Zev Eisenberg on 11/18/21.
//

import SwiftUI

struct RepoListView: View {

    @StateObject var viewModel = RepoListViewModel()

    var body: some View {
        Group {
            if let data = viewModel.data {
                List {
                    Section(content: {
                        ForEach(data.repos, content: RepoView.init(repo:))
                    }, header: {
                        HStack {
                            CircleLabelView(number: data.org.publicRepos, title: "Public Repos", color: .orange)
                            CircleLabelView(number: data.org.followers, title: "Followers", color: .purple)
                            CircleLabelView(number: data.org.following, title: "Following", color: .blue)
                        }
                        .frame(maxWidth: .infinity)
                    })
                }
                .searchable(text: $viewModel.searchString)
            }
            else {
                Text("Loading…")
            }
        }
        .navigationTitle("Repos for Learn Swift Boston")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadRepos()
            }
        }
        .refreshable {
            await viewModel.loadRepos()
        }
        .onChange(of: viewModel.searchString) { _ in
            viewModel.performSearch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RepoListView()
            }

            NavigationView {
                RepoListView()
            }
            .colorScheme(.dark)
        }
    }
}

struct CircleLabelView: View {

    let number: Int
    let title: String
    let color: Color

    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay {
                    VStack {
                        Text(String(number))
                            .font(.system(.largeTitle, design: .rounded))
                    }
                    .foregroundColor(.white)
                }
            Text(title)
                .font(.subheadline)
        }
    }
}
