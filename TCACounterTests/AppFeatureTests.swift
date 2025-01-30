//
//  AppFeatureTests.swift
//  TCACounterTests
//
//  Created by Siran Li on 1/29/25.
//

import Testing
import ComposableArchitecture
@testable import TCACounter

@MainActor
struct AppFeatureTests {
    @Test
    func increatmentIntFirstTap() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
//        await store.send(.tab1(.incrementButtonTapped)) {
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
