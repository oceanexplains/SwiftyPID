//
//  Drone.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI

class Drone: ObservableObject {
    @Published var position: CGPoint
    @Published var velocity: CGPoint
    @Published var angle: CGFloat
    @Published var angularVelocity: CGFloat
    
    let mass: CGFloat
    let inertia: CGFloat
    let gravity: CGFloat
    
    init(position: CGPoint = CGPoint(x: 0, y: 0),
         mass: CGFloat = 1.0,
         inertia: CGFloat = 1.0,
         gravity: CGFloat = 9.81) {
        self.position = position
        self.velocity = CGPoint(x: 0, y: 0)
        self.angle = 0
        self.angularVelocity = 0
        self.mass = mass
        self.inertia = inertia
        self.gravity = gravity
    }
    
    //Pre bars
//    func applyForce(forceX: CGFloat, forceY: CGFloat) {
//        velocity.x += forceX / mass
//        velocity.y += (forceY - mass * gravity) / mass
//    }
    
//    func applyForce(forceX: CGFloat, forceY: CGFloat, offsetX: CGFloat = 0) {
//            velocity.x += forceX / mass
//            velocity.y += (forceY - mass * gravity) / mass
//            applyTorque(torque: forceY * offsetX)
//        }
    func applyForce(forceX: CGFloat, forceY: CGFloat, offsetX: CGFloat = 0) {
        velocity.x += forceX / mass
        velocity.y += (forceY - mass * gravity) / mass
        applyTorque(torque: forceY * offsetX / inertia)
    }
    
    func applyTorque(torque: CGFloat) {
        angularVelocity += torque / inertia
    }
    
    func update(dt: CGFloat) {
        position.x += velocity.x * dt
        position.y += velocity.y * dt
        angle += angularVelocity * dt
    }
}
