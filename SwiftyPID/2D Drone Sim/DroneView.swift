//
//  DroneView.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI

struct DroneView: View {
    @ObservedObject var drone: Drone
    @Binding var leftThrusterForce: CGFloat
    @Binding var rightThrusterForce: CGFloat
    
    var body: some View {
        ZStack {
            // Drone body
            Rectangle()
                .frame(width: 200, height: 20)
            
            // Left thruster flame
            ThrusterFlameView(size: CGSize(width: 10, height: 50 * abs(leftThrusterForce)))
                .offset(x: -95, y: leftThrusterForce > 0 ? -25 : 25)
            
            // Right thruster flame
            ThrusterFlameView(size: CGSize(width: 10, height: 50 * abs(rightThrusterForce)))
                .offset(x: 95, y: rightThrusterForce > 0 ? -25 : 25)
        }
        .position(x: drone.position.x, y: drone.position.y)
        .rotationEffect(Angle(radians: Double(drone.angle)))
    }
}
