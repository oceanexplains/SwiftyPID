//
//  ControlPanelView.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI

struct ControlPanelView: View {
    @Binding var pidController: PIDController
    @Binding var selectedController: Int
    
    var body: some View {
        VStack {
            Picker("Controller", selection: $selectedController) {
                Text("X").tag(0)
                Text("Y").tag(1)
                Text("Orientation").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            VStack {
                Text("Kp: \(pidController.kp, specifier: "%.2f")")
                Slider(value: $pidController.kp, in: 0...2)
                
                Text("Ki: \(pidController.ki, specifier: "%.2f")")
                Slider(value: $pidController.ki, in: 0...2)
                
                Text("Kd: \(pidController.kd, specifier: "%.2f")")
                Slider(value: $pidController.kd, in: 0...2)
            }
            .padding(.horizontal)
        }
    }
}
