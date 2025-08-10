//
//  DeviceData.swift
//  DeviceData1
//
//  Created by andriy kruglyanko on 09.08.2025.
//

import Foundation
import UIKit

// MARK: - Device Data Model
struct DeviceData: Codable {
    let batteryLevel: Float
    let batteryState: String
    let isLowPowerMode: Bool
    let timestamp: Date
    let deviceId: String
    let deviceModel: String

    init(deviceId: String = "",
         timestamp: Date = Date(),
         batteryLevel: Float = 0.0,
         batteryState: String  = "unknown",
         isLowPowerMode: Bool = false,
         deviceModel: String = "unknown",
    ) {
        self.deviceId = deviceId
        self.timestamp = timestamp
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
        self.isLowPowerMode = isLowPowerMode
        self.deviceModel = deviceModel

        print("batteryLevel: \(self.batteryLevel)")
        print( "batteryState: \(self.batteryState)")
        print("isLowPowerMode: \(self.isLowPowerMode)")
        print("timestamp: \(self.timestamp)")
        print("self.deviceId: \(self.deviceId)")
        print("deviceModel = \(self.deviceModel)")

    }

    init(batteryLevel: Float, batteryState: String /*UIDevice.BatteryState = .unknown*/, isLowPowerMode: Bool = false) {
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
        self.isLowPowerMode = isLowPowerMode
        self.timestamp = Date()
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        self.deviceModel = UIDevice.current.model
        print("batteryLevel: \(self.batteryLevel)")
        print( "batteryState: \(self.batteryState)")
        print("isLowPowerMode: \(self.isLowPowerMode)")
        print("timestamp: \(self.timestamp)")
        print("self.deviceId: \(self.deviceId)")
        print("deviceModel = \(self.deviceModel)")

    }
}
