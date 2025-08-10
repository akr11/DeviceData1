//
//  ContentView.swift
//  DeviceData1
//
//  Created by andriy kruglyanko on 07.08.2025.
//

import SwiftUI
import CoreData


// MARK: - Main View
struct ContentView: View {
    @StateObject private var batteryMonitor = BatteryMonitorService()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerView

                        // Battery Status Card
                        batteryStatusCard

                        // Monitoring Controls
                        monitoringControlsCard

                        // Statistics Card
                        statisticsCard

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .navigationTitle("Device Diagnostics")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Для малих екранів
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "bolt.battery.100")
                .font(.system(size: 40))
                .foregroundColor(.green)

            Text("Battery Monitoring")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Collecting device data every 2 minutes")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }

    private var batteryStatusCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: batteryIconName)
                    .font(.title2)
                    .foregroundColor(batteryColor)

                Text("Battery Status")
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Level:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(Int(batteryMonitor.batteryLevel * 100))%")
                        .fontWeight(.semibold)
                        .foregroundColor(batteryColor)
                }

                HStack {
                    Text("State:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(batteryStateText)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }

                // Progress bar
                ProgressView(value: batteryMonitor.batteryLevel)
                    .progressViewStyle(LinearProgressViewStyle(tint: batteryColor))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var monitoringControlsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundColor(.blue)

                Text("Monitoring Controls")
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
            }

            HStack(spacing: 12) {
                Button(action: {
                    if batteryMonitor.isMonitoring {
                        batteryMonitor.stopMonitoring()
                    } else {
                        batteryMonitor.startMonitoring()
                    }
                }) {
                    HStack {
                        Image(systemName: batteryMonitor.isMonitoring ? "stop.fill" : "play.fill")
                        Text(batteryMonitor.isMonitoring ? "Stop" : "Start")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(batteryMonitor.isMonitoring ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                VStack {
                    Circle()
                        .fill(batteryMonitor.isMonitoring ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                        .scaleEffect(batteryMonitor.isMonitoring ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(), value: batteryMonitor.isMonitoring)

                    Text(batteryMonitor.isMonitoring ? "Active" : "Inactive")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(width: 60)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var statisticsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar")
                    .font(.title2)
                    .foregroundColor(.purple)

                Text("Statistics")
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Data sent:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(batteryMonitor.sentDataCount)")
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                }

                HStack {
                    Text("Last update:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(lastUpdateText)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Computed Properties

    private var batteryIconName: String {
        let level = batteryMonitor.batteryLevel
        switch level {
        case 0.75...1.0: return "battery.100"
        case 0.5..<0.75: return "battery.75"
        case 0.25..<0.5: return "battery.50"
        case 0.1..<0.25: return "battery.25"
        default: return "battery.0"
        }
    }

    private var batteryColor: Color {
        let level = batteryMonitor.batteryLevel
        switch level {
        case 0.5...1.0: return .green
        case 0.2..<0.5: return .orange
        default: return .red
        }
    }

    private var batteryStateText: String {
        switch batteryMonitor.batteryState {
        case .unknown: return "Unknown"
        case .unplugged: return "Unplugged"
        case .charging: return "Charging"
        case .full: return "Full"
        @unknown default: return "Unknown"
        }
    }

    private var lastUpdateText: String {
        guard let lastUpdate = batteryMonitor.lastUpdateTime else {
            return "Never"
        }

        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: lastUpdate)
    }
}



// MARK: - Network Status Enum
enum NetworkStatus: String {
    case connected = "Підключено"
    case disconnected = "Відключено"
    case sending = "Відправлення..."
    case error = "Помилка"

    var color: Color {
        switch self {
        case .connected: return .green
        case .disconnected: return .red
        case .sending: return .orange
        case .error: return .red
        }
    }
}
