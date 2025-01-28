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
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store (initialState: CounterFeature.State()) {
                    CounterFeature()
                        ._printChanges()
                }
            )
        }
    }
}
