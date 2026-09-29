// MIT License
// Copyright (c) 2021-2026 LinearMouse

import SwiftUI

struct GeneralSettings: View {
    @AppStorage(UserDefaultsKey.menuBarVisibilityMode) private var menuBarVisibilityMode = MenuBarVisibilityMode.always
    @AppStorage(UserDefaultsKey.showInDock) private var showInDock = true
    @AppStorage(UserDefaultsKey.bypassEventsFromOtherApplications) private var bypassEventsFromOtherApplications = false
    @ObservedObject private var startAtLogin = StartAtLogin.shared

    var body: some View {
        DetailView(schemeSpecific: false) {
            Form {
                Section {
                    Picker(selection: $menuBarVisibilityMode.animation()) {
                        Text("Always").tag(MenuBarVisibilityMode.always)
                        Text("Never").tag(MenuBarVisibilityMode.never)
                    } label: {
                        Text("Show in menu bar")
                    }
                    .modifier(PickerViewModifier())

                    Toggle(isOn: $showInDock) {
                        Text("Show in Dock")
                    }
                }
                .modifier(SectionViewModifier())

                Section {
                    Toggle("Start at login", isOn: Binding(
                        get: { startAtLogin.isEnabled },
                        set: { startAtLogin.setEnabled($0) }
                    ))
                    .onAppear { startAtLogin.refresh() }
                }
                .modifier(SectionViewModifier())

                Section {
                    Toggle(isOn: $bypassEventsFromOtherApplications) {
                        withDescription {
                            Text("Bypass events from other applications")
                            Text(
                                "If enabled, \(LinearMouse.appName) will not modify events sent by other applications, such as Logi Options+."
                            )
                        }
                    }
                }
                .modifier(SectionViewModifier())

                ConfigurationSection()

            }
            .modifier(FormViewModifier())
        }
    }
}
