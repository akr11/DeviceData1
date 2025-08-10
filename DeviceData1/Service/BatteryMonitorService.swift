//
//  BatteryMonitorService.swift
//  DeviceData1
//
//  Created by andriy kruglyanko on 09.08.2025.
//

import Foundation
import UIKit
import Combine


// MARK: - Battery Monitor Service
class BatteryMonitorService: ObservableObject {
    @Published var batteryLevel: Float = 0.0
    @Published var batteryState: UIDevice.BatteryState = .unknown
    @Published var isMonitoring: Bool = false
    @Published var lastUpdateTime: Date?
    @Published var sentDataCount: Int = 0

    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private let networkService = //NetworkService()
    NetworkService.shared
    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

    init() {
        setupBatteryMonitoring()
    }

    /// Ініціалізація моніторингу батареї
    private func setupBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateBatteryInfo()

        // Підписка на зміни стану батареї
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
    }

    @objc private func batteryLevelDidChange() {
        updateBatteryInfo()
    }

    @objc private func batteryStateDidChange() {
        updateBatteryInfo()
    }

    /// Оновлення інформації про батарею
    private func updateBatteryInfo() {
        DispatchQueue.main.async {
            self.batteryLevel = UIDevice.current.batteryLevel
            self.batteryState = UIDevice.current.batteryState
        }
    }

    /// Запуск моніторингу з фоновою роботою
    func startMonitoring() {
        guard !isMonitoring else { return }

        isMonitoring = true
        startBackgroundTask()

        // Таймер для збору даних кожні 2 хвилини
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.collectAndSendData()
        }

        // Перший збір даних
        collectAndSendData()
    }

    /// Зупинка моніторингу
    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        endBackgroundTask()
    }

    /// Збір і відправка даних
    private func collectAndSendData() {
        let batteryData =
        DeviceData(
            deviceId: deviceId,
            timestamp: Date(),
            batteryLevel: UIDevice.current.batteryLevel,
            batteryState: batteryStateString(UIDevice.current.batteryState),
            deviceModel: UIDevice.current.model
        )

        print("update : ")
        print("\(batteryData.deviceId) - \(Int(batteryData.batteryLevel * 100))")
        print("\(batteryData.batteryState) - \(batteryData.timestamp)")
        // Відправка даних асинхронно
        Task {
            do {
                try await networkService.sendDeviceData(batteryData)

                await MainActor.run {
                    self.lastUpdateTime = Date()
                    self.sentDataCount += 1
                }
            } catch {
                print("❌ Error sending data: \(error)")
            }
        }
    }

    /// Конвертація стану батареї в строку
    private func batteryStateString(_ state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown: return "unknown"
        case .unplugged: return "unplugged"
        case .charging: return "charging"
        case .full: return "full"
        @unknown default: return "unknown"
        }
    }

        /// Отримує стан батареї як рядок
        private var batteryStateString: String {
            switch UIDevice.current.batteryState {
            case .charging: return "charging"
            case .full: return "full"
            case .unplugged: return "unplugged"
            case .unknown: return "unknown"
            @unknown default: return "unknown"
            }
        }

    /// Запуск фонового завдання
    private func startBackgroundTask() {
        endBackgroundTask() // Завершуємо попереднє, якщо є

        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "BatteryMonitoring") {
            // Час фонової роботи закінчується
            self.endBackgroundTask()
        }
    }

    /// Завершення фонового завдання
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    deinit {
        stopMonitoring()
        NotificationCenter.default.removeObserver(self)
    }
}
