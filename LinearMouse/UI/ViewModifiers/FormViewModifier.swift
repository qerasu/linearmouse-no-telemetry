// MIT License
// Copyright (c) 2021-2026 LinearMouse

import SwiftUI

struct FormViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.formStyle(.grouped)
    }
}

struct SectionViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct PickerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct SettingsDescriptionViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    func settingsDescriptionStyle() -> some View {
        modifier(SettingsDescriptionViewModifier())
    }
}

func withDescription<View1: View, View2: View>(@ViewBuilder content: () -> TupleView<(View1, View2)>) -> some View {
    let c = content()
    return Group {
        c.value.0
        c.value.1.settingsDescriptionStyle()
    }
}

func labelWithDescription<
    View1: View,
    View2: View
>(@ViewBuilder content: () -> TupleView<(View1, View2)>) -> some View {
    let c = content()

    return Group {
        c.value.0
        c.value.1
    }
}
