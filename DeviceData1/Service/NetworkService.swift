//
//  Untitled.swift
//  DeviceData1
//
//  Created by andriy kruglyanko on 09.08.2025.
//

// MARK: - Network Service
import Foundation
import Network
import Combine
import SwiftUICore

// MARK: - Network Service


class NetworkService: ObservableObject {
    static let shared = NetworkService()
    private let session = URLSession.shared
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"

    private init() {}

    /// Відправляє дані на сервер з базовим захистом
    func sendDeviceData(_ data: DeviceData) async throws {
        // Створюємо захищений пакет даних
        let securePacket = try SecureDataPacket(deviceData: data)

        // Налаштовуємо запит
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("DataCollector/1.0", forHTTPHeaderField: "User-Agent")

        // Кодуємо дані
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(securePacket)

        // Відправляємо запит
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        print("✅ Data sent successfully: \(data.count) bytes")
    }

    enum NetworkError: LocalizedError {
        case invalidResponse
        case serverError(Int)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid server response"
            case .serverError(let code):
                return "Server error: \(code)"
            }
        }
    }

    
    
}
