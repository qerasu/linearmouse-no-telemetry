// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Combine
import Foundation
import SwiftUI

class DeviceState: ObservableObject {
    static let shared = DeviceState()

    private var subscriptions = Set<AnyCancellable>()
    private var isUpdatingCurrentDeviceRef = false

    @Published var currentDeviceMatcher: DeviceMatcher?

    @Published var currentDeviceRef: WeakRef<Device>? {
        didSet {
            guard !isUpdatingCurrentDeviceRef else {
                return
            }

            guard !UserDefaults.standard.autoSwitchToActiveDevice else {
                return
            }

            let currentDeviceMatcher = currentDeviceRef?.value.map { DeviceMatcher(of: $0) }
            guard UserDefaults.standard.selectedDeviceMatcher != currentDeviceMatcher else {
                return
            }

            UserDefaults.standard.selectedDeviceMatcher = currentDeviceMatcher
        }
    }

    init() {
        let defaults = UserDefaults.standard
        let devicePreferenceState = (defaults.autoSwitchToActiveDevice, defaults.selectedDeviceMatcher)
        let devicePreferenceChanges = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .map { _ -> (Bool, DeviceMatcher?) in
                (defaults.autoSwitchToActiveDevice, defaults.selectedDeviceMatcher)
            }
        devicePreferenceChanges
            .prepend(devicePreferenceState)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateCurrentDevice()
            }
            .store(in: &subscriptions)

        deviceManager.$lastActiveDeviceRef
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] lastActiveDeviceRef in
                self?.updateCurrentDeviceRef(lastActiveDeviceRef: lastActiveDeviceRef)
            }
            .store(in: &subscriptions)

        deviceManager.$devices
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateCurrentDevice()
            }
            .store(in: &subscriptions)
    }
}

extension DeviceState {
    private var deviceManager: DeviceManager {
        DeviceManager.shared
    }

    private func setCurrentDeviceRef(_ deviceRef: WeakRef<Device>?) {
        if currentDeviceRef?.value !== deviceRef?.value {
            SettingsState.shared.endButtonMappingRecording()
        }

        isUpdatingCurrentDeviceRef = true
        currentDeviceRef = deviceRef
        isUpdatingCurrentDeviceRef = false
    }

    private func exactMatcher(of deviceRef: WeakRef<Device>?) -> DeviceMatcher? {
        deviceRef?.value.map { DeviceMatcher(of: $0) }
    }

    private func updateCurrentDeviceRef(lastActiveDeviceRef: WeakRef<Device>?) {
        guard !UserDefaults.standard.autoSwitchToActiveDevice else {
            setCurrentDeviceRef(lastActiveDeviceRef)
            currentDeviceMatcher = exactMatcher(of: lastActiveDeviceRef)
            return
        }

        guard let userSelectedDevice = UserDefaults.standard.selectedDeviceMatcher else {
            setCurrentDeviceRef(lastActiveDeviceRef)
            currentDeviceMatcher = exactMatcher(of: lastActiveDeviceRef)
            return
        }

        let matchedDeviceRef = deviceManager.devices
            .first { userSelectedDevice.match(with: $0) }
            .map { WeakRef($0) }

        setCurrentDeviceRef(matchedDeviceRef ?? lastActiveDeviceRef)
        currentDeviceMatcher = userSelectedDevice
    }

    private func updateCurrentDevice() {
        updateCurrentDeviceRef(lastActiveDeviceRef: deviceManager.lastActiveDeviceRef)
    }
}
