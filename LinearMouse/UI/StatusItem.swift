// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Combine
import Defaults
import SwiftUI

class StatusItem: NSObject {
    static let shared = StatusItem()

    private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private var subscriptions = Set<AnyCancellable>()

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.items = baseMenuItems()

        return menu
    }()

    private lazy var openSettingsItem: NSMenuItem = {
        let item = NSMenuItem(
            title: String(format: NSLocalizedString("%@ Settings…", comment: ""), LinearMouse.appName),
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        item.target = self
        return item
    }()

    private lazy var configurationItem: NSMenuItem = {
        let item = NSMenuItem(
            title: NSLocalizedString("Config", comment: ""),
            action: nil,
            keyEquivalent: ""
        )
        item.submenu = configurationMenu
        return item
    }()

    private lazy var startAtLoginItem: NSMenuItem = {
        let item = NSMenuItem(
            title: String(format: NSLocalizedString("Start at login", comment: "")),
            action: #selector(toggleStartAtLogin),
            keyEquivalent: ""
        )
        item.target = self
        return item
    }()

    private lazy var openSettingsForFrontmostApplicationItem: NSMenuItem = {
        let item = NSMenuItem(
            title: "",
            action: #selector(openSettingsForFrontmostApplication),
            keyEquivalent: ""
        )
        item.target = self
        return item
    }()

    private lazy var quitItem: NSMenuItem = {
        let item = NSMenuItem(
            title: String(format: NSLocalizedString("Quit %@", comment: ""), LinearMouse.appName),
            action: #selector(quit),
            keyEquivalent: "q"
        )
        item.target = self
        return item
    }()

    private lazy var configurationMenu: NSMenu = {
        let configurationMenu = NSMenu()

        let reloadItem = NSMenuItem(
            title: NSLocalizedString("Reload", comment: ""),
            action: #selector(reloadConfiguration),
            keyEquivalent: "r"
        )

        let revealInFinderItem = NSMenuItem(
            title: NSLocalizedString("Reveal in Finder", comment: ""),
            action: #selector(revealConfigurationInFinder),
            keyEquivalent: "r"
        )
        revealInFinderItem.keyEquivalentModifierMask = [.option, .command]

        configurationMenu.items = [
            reloadItem,
            revealInFinderItem
        ]

        configurationMenu.items.forEach { $0.target = self }

        return configurationMenu
    }()

    override init() {
        super.init()

        Self.migrateMenuBarVisibilityModeIfNeeded()

        if let button = statusItem.button {
            button.image = NSImage(named: "MenuIcon")
            button.imagePosition = .imageOnly
            button.action = #selector(statusItemAction(sender:))
            button.target = self
        }

        updateStatusItemPresentation()

        StartAtLogin.shared.refresh()
        StartAtLogin.shared.$isEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.startAtLoginItem.state = enabled ? .on : .off
            }
            .store(in: &subscriptions)

        updateOpenSettingsForFrontmostApplicationItem()
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateOpenSettingsForFrontmostApplicationItem()
            StartAtLogin.shared.refresh()
        }

        AccessibilityPermission.pollingUntilEnabled { [weak self] in
            self?.setup()
        }
    }

    private static func migrateMenuBarVisibilityModeIfNeeded() {
        if !Defaults[.menuBarVisibilityModeMigrationCompleted] {
            Defaults[.menuBarVisibilityMode] = Defaults[.showInMenuBar] ? .always : .never
            Defaults[.menuBarVisibilityModeMigrationCompleted] = true
        }

        if Defaults[.menuBarVisibilityMode] == .whenAttentionNeeded {
            Defaults[.menuBarVisibilityMode] = .always
        }
    }

    private static func syncLegacyShowInMenuBar() {
        Defaults[.showInMenuBar] = Defaults[.menuBarVisibilityMode] != .never
    }

    private func updateStatusItemPresentation() {
        statusItem.isVisible = Defaults[.menuBarVisibilityMode] != .never
    }

    private func baseMenuItems() -> [NSMenuItem] {
        [
            openSettingsItem,
            .separator(),
            configurationItem,
            startAtLoginItem,
            .separator(),
            openSettingsForFrontmostApplicationItem,
            quitItem
        ]
    }

    private func updateOpenSettingsForFrontmostApplicationItem() {
        guard let application = NSWorkspace.shared.frontmostApplication,
              let name = Self.frontmostApplicationName(application) else {
            openSettingsForFrontmostApplicationItem.isHidden = true
            return
        }
        openSettingsForFrontmostApplicationItem.isHidden = false
        openSettingsForFrontmostApplicationItem.title = String(
            format: NSLocalizedString("Configure for %@…", comment: ""),
            name
        )
    }

    private static func frontmostApplicationName(_ application: NSRunningApplication) -> String? {
        application.localizedName ??
            application.bundleURL?.deletingPathExtension().lastPathComponent ??
            application.bundleIdentifier
    }

    private func setup() {
        statusItem.menu = menu

        Defaults.observe(.menuBarVisibilityMode) { [weak self] _ in
            guard let self else {
                return
            }

            Self.syncLegacyShowInMenuBar()
            self.updateStatusItemPresentation()
        }
        .tieToLifetime(of: self)
    }

    @objc private func statusItemAction(sender _: NSStatusBarButton) {
        guard !AccessibilityPermission.enabled else {
            return
        }

        AccessibilityPermissionWindow.shared.bringToFront()
    }

    @objc private func openSettings() {
        SchemeState.shared.currentApp = nil
        SchemeState.shared.currentDisplay = nil
        SettingsWindowController.shared.bringToFront()
    }

    @objc private func openSettingsForFrontmostApplication() {
        let frontmostApplication = NSWorkspace.shared.frontmostApplication
        if let bundleIdentifier = frontmostApplication?.bundleIdentifier {
            SchemeState.shared.currentApp = .bundle(bundleIdentifier)
        } else if let executableName = frontmostApplication?.executableURL?.lastPathComponent {
            SchemeState.shared.currentApp = .executableName(executableName)
        } else {
            SchemeState.shared.currentApp = nil
        }
        SettingsWindowController.shared.bringToFront()
    }

    @objc private func reloadConfiguration() {
        ConfigurationState.shared.reloadFromDisk()
    }

    @objc private func revealConfigurationInFinder() {
        ConfigurationState.shared.revealInFinder()
    }

    @objc private func toggleStartAtLogin() {
        let startAtLogin = StartAtLogin.shared
        startAtLogin.refresh()
        startAtLogin.setEnabled(!startAtLogin.isEnabled)
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
