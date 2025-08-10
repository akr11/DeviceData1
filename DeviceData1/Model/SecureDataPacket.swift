//
//  SecureDataPacket.swift
//  DeviceData1
//
//  Created by andriy kruglyanko on 09.08.2025.
//

import Foundation

/// Модель для відправки на сервер (з Base64 кодуванням)
struct SecureDataPacket: Codable {
    let data: String // Base64 encoded DeviceData
    let checksum: String // Простий checksum для перевірки цілісності

    init(deviceData: DeviceData) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(deviceData)

        self.data = jsonData.base64EncodedString()
        self.checksum = String(jsonData.hashValue)
    }
}
