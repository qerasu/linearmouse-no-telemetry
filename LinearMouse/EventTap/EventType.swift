// MIT License
// Copyright (c) 2021-2026 LinearMouse

class EventType {
    static let all: [CGEventType] = [
        .scrollWheel,
        .leftMouseDown,
        .leftMouseUp,
        .leftMouseDragged,
        .rightMouseDown,
        .rightMouseUp,
        .rightMouseDragged,
        .otherMouseDown,
        .otherMouseUp,
        .otherMouseDragged,
        .flagsChanged
    ]

    static let mouseMoved: CGEventType = .mouseMoved
}
