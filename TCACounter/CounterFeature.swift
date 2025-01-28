//
//  CounterFeature.swift
//  TCACounter
//
//  Created by Siran Li on 1/28/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature: Reducer {
    @ObservableState
    struct State {
        var count = 0
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
//    var body: some Reducer<State, Action> {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    return .none
                case .incrementButtonTapped:
                    state.count += 1
                    return .none
            }
        }
    }
}
