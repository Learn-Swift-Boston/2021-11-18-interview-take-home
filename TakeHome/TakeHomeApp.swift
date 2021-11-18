//
//  TakeHomeApp.swift
//  TakeHome
//
//  Created by Zev Eisenberg on 11/18/21.
//

import SwiftUI

@main
struct TakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RepoListView()
            }
        }
    }
}
