//
//  RepoView.swift
//  TakeHome
//
//  Created by Zev Eisenberg on 11/18/21.
//

import SwiftUI

struct RepoView: View {

    let repo: Repo

    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: repo.name)
                .font(.headline)
            Text(verbatim: repo.updatedAt.formatted(.dateTime.year().month().day()))
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView(repo: .init(
            id: 1234,
            name: "My cool repo",
            htmlUrl: URL(string: "https://github.com/Learn-Swift-Boston/2021-09-16-ZeroToApp-CameraNote")!,
            description: "Quick sketch of a SwiftUI app to capture photos and display them in a grid",
            createdAt: Date(),
            updatedAt: Date())
        )
            .frame(width: 320)
            .previewLayout(.sizeThatFits)
    }
}
