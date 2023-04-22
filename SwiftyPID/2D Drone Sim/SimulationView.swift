//
//  SimulationView.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI

struct SimulationView: View {
    @ObservedObject var drone = Drone(position: CGPoint(x: 200, y: 300))
    
    @State private var targetPosition = CGPoint(x: 200, y: 100)
    @State private var dt: CGFloat = 0.01
    
    @State private var pidControllerX = PIDController(kp: 0.5, ki: 0.1, kd: 0.05)
    @State private var pidControllerY = PIDController(kp: 1.0, ki: 0.2, kd: 0.1)
    @State private var pidControllerOrientation = PIDController(kp: 50, ki: 0.5, kd: 5)
    
    @State private var leftThrusterForce: CGFloat = 0
    @State private var rightThrusterForce: CGFloat = 0
    
    @State private var selectedController: Int = 0
    
    var body: some View {
        ZStack {
            DraggableTargetView(targetPosition: $targetPosition)
            DroneView(drone: drone, leftThrusterForce: $leftThrusterForce, rightThrusterForce: $rightThrusterForce)
            
            ControlPanelView(pidController: .init(get: {
                switch self.selectedController {
                case 0:
                    return self.pidControllerX
                case 1:
                    return self.pidControllerY
                case 2:
                    return self.pidControllerOrientation
                default:
                    return self.pidControllerX
                }
            }, set: { newController in
                switch self.selectedController {
                case 0:
                    self.pidControllerX = newController
                case 1:
                    self.pidControllerY = newController
                case 2:
                    self.pidControllerOrientation = newController
                default:
                    self.pidControllerX = newController
                }
            }))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: Double(dt), repeats: true) { _ in
                let controlActionX = pidControllerX.updateControlAction(target: targetPosition.x, current: drone.position.x, dt: dt)
                let controlActionY = pidControllerY.updateControlAction(target: targetPosition.y, current: drone.position.y, dt: dt)
                let controlActionOrientation = pidControllerOrientation.updateControlAction(target: 0, current: drone.angle, dt: dt)
                
                drone.applyForce(forceX: controlActionX, forceY: controlActionY)
                drone.applyTorque(torque: controlActionOrientation)
                drone.update(dt: dt)
            }
        }
    }
}
