//
//  CounterFeature.swift
//  TCACounter
//
//  Created by Siran Li on 1/28/25.
//

import Foundation
import ComposableArchitecture

struct NumberFactClient {
    var fetch: @Sendable (Int) async throws -> String
}
extension NumberFactClient: DependencyKey {
    static let liveValue = Self {
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    }
}
extension DependencyValues {
    var NumberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}

@Reducer
struct CounterFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    private enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    state.fact = nil
                    return .none
                    
                case .incrementButtonTapped:
                    state.count += 1
                    state.fact = nil
                    return .none
                    
                case .factButtonTapped:
                    state.fact = nil
                    state.isLoading = true
                    return .run { [count = state.count] send in
                        try await send(.factResponse(self.numberFact.fetchFact(count)))
                    }
                    
                case .factResponse(let fact):
                    state.fact = fact
                    state.isLoading = false
                    return .none
                    
                case .toggleTimerButtonTapped:
                    state.isTimerRunning.toggle()
                    if state.isTimerRunning {
                        return .run { send in
                            for await _ in self.clock.timer(interval: .seconds(1)) {
                                await send(.timerTick)
                            }
                        }
                        .cancellable(id: CancelID.timer)
                    } else {
                        return .cancel(id: CancelID.timer)
                    }
                    
                case .timerTick:
                    state.count += 1
                    return .none
            }
        }
    }
}
