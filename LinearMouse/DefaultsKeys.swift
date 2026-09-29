// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Foundation

enum UserDefaultsKey {
    static let showInMenuBar = "showInMenuBar"
    static let menuBarVisibilityMode = "menuBarVisibilityMode"
    static let menuBarVisibilityModeMigrationCompleted = "menuBarVisibilityModeMigrationCompleted"
    static let showInDock = "showInDock"
    static let bypassEventsFromOtherApplications = "bypassEventsFromOtherApplications"
    static let autoSwitchToActiveDevice = "autoSwitchToActiveDevice"
    static let selectedDevice = "selectedDevice"
}

enum MenuBarVisibilityMode: String, Codable {
    case always
    case whenAttentionNeeded
    case never
}

extension UserDefaults {
    var showInMenuBar: Bool {
        get { object(forKey: UserDefaultsKey.showInMenuBar) as? Bool ?? true }
        set { set(newValue, forKey: UserDefaultsKey.showInMenuBar) }
    }

    var menuBarVisibilityMode: MenuBarVisibilityMode {
        get {
            MenuBarVisibilityMode(rawValue: string(forKey: UserDefaultsKey.menuBarVisibilityMode) ?? "") ?? .always
        }
        set { set(newValue.rawValue, forKey: UserDefaultsKey.menuBarVisibilityMode) }
    }

    var menuBarVisibilityModeMigrationCompleted: Bool {
        get { object(forKey: UserDefaultsKey.menuBarVisibilityModeMigrationCompleted) as? Bool ?? false }
        set { set(newValue, forKey: UserDefaultsKey.menuBarVisibilityModeMigrationCompleted) }
    }

    var showInDock: Bool {
        get { object(forKey: UserDefaultsKey.showInDock) as? Bool ?? true }
        set { set(newValue, forKey: UserDefaultsKey.showInDock) }
    }

    var bypassEventsFromOtherApplications: Bool {
        get { object(forKey: UserDefaultsKey.bypassEventsFromOtherApplications) as? Bool ?? false }
        set { set(newValue, forKey: UserDefaultsKey.bypassEventsFromOtherApplications) }
    }

    var autoSwitchToActiveDevice: Bool {
        get { object(forKey: UserDefaultsKey.autoSwitchToActiveDevice) as? Bool ?? true }
        set { set(newValue, forKey: UserDefaultsKey.autoSwitchToActiveDevice) }
    }

    var selectedDeviceMatcher: DeviceMatcher? {
        get {
            guard let data = string(forKey: UserDefaultsKey.selectedDevice)?.data(using: .utf8) else {
                return nil
            }
            return try? JSONDecoder().decode(DeviceMatcher.self, from: data)
        }
        set {
            guard let newValue else {
                removeObject(forKey: UserDefaultsKey.selectedDevice)
                return
            }
            guard let data = try? JSONEncoder().encode(newValue),
                  let value = String(data: data, encoding: .utf8) else {
                return
            }
            set(value, forKey: UserDefaultsKey.selectedDevice)
        }
    }
}
