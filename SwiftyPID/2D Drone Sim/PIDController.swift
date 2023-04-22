//
//  PIDController.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI

class PIDController {
    var kp: CGFloat
    var ki: CGFloat
    var kd: CGFloat
    
    private var previousError: CGFloat = 0
    private var integralError: CGFloat = 0
    private var derivativeError: CGFloat = 0
    
    init(kp: CGFloat, ki: CGFloat, kd: CGFloat) {
        self.kp = kp
        self.ki = ki
        self.kd = kd
    }
    
    func updateControlAction(target: CGFloat, current: CGFloat, dt: CGFloat) -> CGFloat {
        let error = target - current
        integralError += error * dt
        derivativeError = (error - previousError) / dt
        previousError = error
        
        return kp * error + ki * integralError + kd * derivativeError
    }
}
