//
//  TiltViewModel.swift
//  IsTilted
//
//  ViewModel — owns TiltService, exposes UI-ready state.
//

import Foundation
import Combine

class TiltViewModel: ObservableObject {

    @Published var rollDegrees: Double = 0.0
    @Published var pitchDegrees: Double = 0.0
    @Published var isRunning: Bool = false
    @Published var isLevel: Bool = true
    @Published var errorMessage: String? = nil

    private let tiltService: TiltService = TiltService()

    // Dead-zone threshold in degrees — prevents flickering near level
    private let threshold: Double = 7.0

    var statusText: String {
        if !isRunning {
            return "Tap Start to begin"
        }
        return isLevel ? "LEVEL" : "TILTED"
    }
    
    var statusSystemImageName: String {
        if !isRunning {
            return "play.circle"
        }
        return isLevel ? "checkmark.circle" : "exclamationmark.triangle"
    }

    var rollFormatted: String {
        return String(format: "%.1f°", rollDegrees)
    }

    var pitchFormatted: String {
        return String(format: "%.1f°", pitchDegrees)
    }

    func start() {
        if isRunning { return }
        isRunning = true
        errorMessage = nil

        if !tiltService.isDeviceMotionAvailable {
            errorMessage = "Device motion not available on this device."
            isRunning = false
            return
        }

        tiltService.startUpdates { (roll: Double, pitch: Double) in
            self.updateValues(rollRad: roll, pitchRad: pitch)
        }
    }

    func stop() {
        tiltService.stopUpdates()
        isRunning = false
    }

    func reset() {
        stop()
        rollDegrees = 0.0
        pitchDegrees = 0.0
        isLevel = true
        errorMessage = nil
    }

    private func updateValues(rollRad: Double, pitchRad: Double) {
        // Convert radians to degrees
        let rollDeg: Double = rollRad * 180.0 / .pi
        let pitchDeg: Double = pitchRad * 180.0 / .pi

        self.rollDegrees = rollDeg
        self.pitchDegrees = pitchDeg

        let rollAbs: Double = abs(rollDeg)
        let pitchAbs: Double = abs(pitchDeg)
        self.isLevel = (rollAbs < threshold) && (pitchAbs < threshold)
    }
}

