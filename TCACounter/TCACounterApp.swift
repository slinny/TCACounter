//
//  TCACounterApp.swift
//  TCACounter
//
//  Created by Siran Li on 1/27/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCACounterApp: App {
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCACounterApp.store)
        }
    }
}
