// MIT License
// Copyright (c) 2021-2026 LinearMouse

import AppKit
import Combine
import ServiceManagement

final class StartAtLogin: ObservableObject {
    static let shared = StartAtLogin()

    @Published private(set) var isEnabled = SMAppService.mainApp.status == .enabled

    private init() {}

    func refresh() {
        isEnabled = SMAppService.mainApp.status == .enabled
    }

    func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSAlert(error: error).runModal()
        }
        refresh()
    }
}
