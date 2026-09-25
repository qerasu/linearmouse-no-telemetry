// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Defaults
import Foundation

enum MenuBarVisibilityMode: String, Codable, Defaults.Serializable {
    case always
    case whenAttentionNeeded
    case never
}

extension Defaults.Keys {
    static let showInMenuBar = Key<Bool>("showInMenuBar", default: true)
    static let menuBarVisibilityMode = Key<MenuBarVisibilityMode>("menuBarVisibilityMode", default: .always)
    static let menuBarVisibilityModeMigrationCompleted = Key<Bool>(
        "menuBarVisibilityModeMigrationCompleted",
        default: false
    )
    static let showInDock = Key<Bool>("showInDock", default: true)

    static let bypassEventsFromOtherApplications = Key("bypassEventsFromOtherApplications", default: false)

}
