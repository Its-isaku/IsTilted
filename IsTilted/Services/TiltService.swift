//
//  TiltService.swift
//  IsTilted
//
//  CoreMotion wrapper — reads roll & pitch from deviceMotion.
//

import Foundation
import CoreMotion

class TiltService {

    // The one and only motion manager for this app
    private let motionManager: CMMotionManager = CMMotionManager()

    // Background queue so sensor work stays off the main thread
    private let motionQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.istilted.motionQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    // Check if device motion is available (Simulator = false)
    var isDeviceMotionAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }

    // Start reading roll & pitch
    // onUpdate: callback with (rollRadians, pitchRadians)
    func startUpdates(onUpdate: @escaping (Double, Double) -> Void) {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 0.1 // 10 times per second

        motionManager.startDeviceMotionUpdates(to: motionQueue) { (data, error) in
            if let safeData: CMDeviceMotion = data {
                let roll: Double = safeData.attitude.roll
                let pitch: Double = safeData.attitude.pitch

                // Send values back to the main thread for UI
                DispatchQueue.main.async {
                    onUpdate(roll, pitch)
                }
            }
        }
    }

    // Stop all motion updates
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
