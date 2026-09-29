// MIT License
// Copyright (c) 2021-2026 LinearMouse

import SwiftUI

struct Settings: View {
    @AppStorage(UserDefaultsKey.showInDock) private var showInDock = true

    var body: some View {
        EmptyView()
            .onAppear(perform: updateActivationPolicy)
            .onChange(of: showInDock) { _ in
                updateActivationPolicy()
            }
            .onDisappear {
                NSApplication.shared.setActivationPolicy(.accessory)
            }
    }

    private func updateActivationPolicy() {
        if showInDock {
            NSApplication.shared.setActivationPolicy(.regular)
        } else {
            NSApplication.shared.setActivationPolicy(.accessory)
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
}
