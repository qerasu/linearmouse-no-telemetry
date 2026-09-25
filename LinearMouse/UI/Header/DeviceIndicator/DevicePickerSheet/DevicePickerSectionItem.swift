// MIT License
// Copyright (c) 2021-2026 LinearMouse

import SwiftUI

struct DevicePickerSectionItem: View {
    @ObservedObject var deviceModel: DeviceModel
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(deviceModel.pairedReceiverDevices.isEmpty ? deviceModel.displayName : deviceModel.name)
                            .font(.body)

                        if deviceModel.isActive {
                            Text("(active)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if isSelected, #available(macOS 11.0, *) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                    }
                }

                if !deviceModel.pairedReceiverDevices.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(deviceModel.pairedReceiverDevices, id: \.slot) { device in
                            Text(String(format: NSLocalizedString("- %@", comment: ""), device.name))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 12)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .move(edge: .top))
                        )
                    )
                }
            }
            .transition(
                .asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.97, anchor: .top)),
                    removal: .opacity
                )
            )
            .frame(
                maxWidth: .infinity,
                minHeight: deviceModel.pairedReceiverDevices.isEmpty ? 38 : 58,
                alignment: .leading
            )
            .animation(
                .spring(response: 0.26, dampingFraction: 0.88),
                value: deviceModel.pairedReceiverDevices.map(\.slot)
            )
        }
        .buttonStyle(DeviceButtonStyle(isSelected: isSelected))
    }
}

struct DevicePickerCategoryItem: View {
    var category: DeviceMatcher.Category
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(category.devicePickerTitle)
                        .font(.body)
                    Text(category.devicePickerDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isSelected, #available(macOS 11.0, *) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        }
        .buttonStyle(DeviceButtonStyle(isSelected: isSelected))
    }
}

private extension DeviceMatcher.Category {
    var devicePickerTitle: LocalizedStringKey {
        switch self {
        case .mouse:
            return "All Mice"
        case .trackpad:
            return "All Trackpads"
        }
    }

    var devicePickerDescription: LocalizedStringKey {
        switch self {
        case .mouse:
            return "Applies to every mouse."
        case .trackpad:
            return "Applies to every trackpad."
        }
    }
}
