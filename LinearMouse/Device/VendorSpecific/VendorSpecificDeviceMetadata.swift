// MIT License
// Copyright (c) 2021-2026 LinearMouse

import Foundation
import HIDPP

protocol VendorSpecificDeviceContext: HIDPPDeviceIO {
    var vendorID: Int? { get }
    var productID: Int? { get }
    var product: String? { get }
    var name: String { get }
    var serialNumber: String? { get }
    var transport: String? { get }
    var locationID: Int? { get }
    var primaryUsagePage: Int? { get }
    var primaryUsage: Int? { get }
    var maxInputReportSize: Int? { get }
    var maxOutputReportSize: Int? { get }
    var maxFeatureReportSize: Int? { get }
}
