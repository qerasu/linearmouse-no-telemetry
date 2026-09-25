// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Carbon
@testable import KeyKit
import XCTest

final class KeySimulatorEventFieldsTests: XCTestCase {
    /// Simulated key events must be indistinguishable from hardware ones:
    /// events without HID system state, with a zero timestamp or without a
    /// keyboard type break mouse capture in some event consumers (e.g. Wine
    /// games holding a mouse button to rotate the camera).
    func testSimulatedKeyEventsMimicHardwareEvents() throws {
        var recordedEvents: [CGEvent] = []
        let simulator = KeySimulator { event, _ in
            recordedEvents.append(event)
        }

        let before = DispatchTime.now().uptimeNanoseconds
        try simulator.press(keys: [.f1], tap: nil)
        let after = DispatchTime.now().uptimeNanoseconds

        XCTAssertEqual(recordedEvents.map(\.type), [.keyDown, .keyUp])
        for event in recordedEvents {
            XCTAssertEqual(
                event.getIntegerValueField(.eventSourceStateID),
                Int64(CGEventSourceStateID.hidSystemState.rawValue)
            )
            XCTAssertGreaterThanOrEqual(event.timestamp, before)
            XCTAssertLessThanOrEqual(event.timestamp, after)
            XCTAssertEqual(
                event.getIntegerValueField(.keyboardEventKeyboardType),
                Int64(LMGetKbdType())
            )
        }
    }
}
