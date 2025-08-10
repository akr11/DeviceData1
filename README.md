# DeviceData1
Overview
DeviceData1 is a simple iOS application built with SwiftUI that monitors device battery information, including level, state, and low power mode. It periodically collects this data (every 10 seconds when active) and sends it to a remote server for logging or analysis. The app supports basic background execution and provides a user-friendly interface to start/stop monitoring and view real-time statistics.
This app is designed for diagnostic purposes, such as tracking battery usage in testing environments or fleet management. Note: It uses a placeholder API endpoint for data submission; replace with a production server for real use.
Created by: Andriy Kruglyanko

Creation Date: August 7, 2025

Version: 1.0
Features

Real-Time Battery Monitoring: Displays current battery level (as percentage and progress bar), state (e.g., charging, full), and low power mode status.
Periodic Data Collection: Collects and sends device data (battery level, state, low power mode, timestamp, device ID, model) every 10 seconds (configurable).
Background Support: Attempts to run in the background using UIBackgroundTask, with plist configurations for background processing and fetch.
Secure Data Transmission: Data is JSON-encoded, Base64-wrapped, and sent via HTTPS POST with a basic checksum (Note: Enhance for production security).
User Interface: SwiftUI-based dashboard with cards for status, controls, and statistics. Includes start/stop button, activity indicator, and sent data count.
Notifications: Listens for battery level/state changes and low power mode toggles, updating the UI and optionally sending data.

Requirements

iOS 14.0 or later
Xcode 16.0 or later
Swift 5.0+

Usage

Launch the app.
View the Battery Status Card for current battery info.
In the Monitoring Controls Card, tap "Start" to begin periodic data collection and sending.

The indicator will turn green and animate when active.
Data is sent to https://jsonplaceholder.typicode.com/posts (fake API; logs success in console).


Tap "Stop" to halt monitoring.
Check the Statistics Card for sent data count and last update time.

Note: For background monitoring, ensure the app has background refresh permissions enabled in Settings. The current implementation provides limited background time (~30 seconds); for extended background tasks, integrate BGTaskScheduler fully.

Architecture
Key Components

DeviceData.swift: Data model for battery information (Codable for JSON encoding).
SecureDataPacket.swift: Wrapper for Base64-encoded data with a simple checksum.
BatteryMonitorService.swift: ObservableObject handling monitoring logic, notifications, timer, and background tasks.
NetworkService.swift: Singleton for async HTTP POST requests to send data.
ContentView.swift: Main SwiftUI view with cards for display and controls.
DeviceData1App.swift: App entry point.

Known Issues & Improvements

Timer Interval Mismatch: Code uses 10 seconds, but comments mention 2 minutes – align as needed.
Low Power Mode Monitoring: Fully implemented with notifications.
Background Execution: Limited to short bursts; implement BGTaskScheduler for true periodic background tasks.
Security: Base64 + hashValue checksum is minimal; add proper encryption (e.g., AES) and HMAC.
Device Model: Generic (e.g., "iPhone"); extend to specific hardware identifiers if required.
Error Handling: Basic; add retries, offline queuing.
Privacy: Device ID allows tracking; ensure compliance with App Store guidelines.
Testing: Uses fake API; test with real server. No unit tests included – add for robustness.

Potential Issues and Improvements

Inconsistencies/Bugs:

Timer interval (10s vs. commented 2min) – fix to match intent.
isLowPowerMode always false – add monitoring

let isLowPower = ProcessInfo.processInfo.isLowPowerModeEnabled

Background execution limited; integrate BGTaskScheduler.submit(BGProcessingTaskRequest(identifier: "battery.monitor")) for true background processing.


