//
//  RealtimeState.swift
//  OpenAIRealtime
//
//  Created by Lou Zell on 3/14/25.
//

enum RealtimeState: String {
    case stopped
    case starting
    case started

    mutating func userToggle() {
        switch self {
        case .stopped:
            self = .starting
        case .starting:
            self = .stopped
        case .started:
            self = .stopped
        }
    }
}
