//
//  RotatingBarView.swift
//  SwiftyPID
//
//  Created by Tomer Zed on 4/21/23.
//

import SwiftUI

import SwiftUI

struct SliderRotatingBarView: View {
    @State private var sliderValue: Double = 0.5
    
    var body: some View {
        VStack {
            RotatingBarView(sliderValue: $sliderValue)
            Slider(value: $sliderValue)
        }
        .padding()
    }
}

struct RotatingBarView: View {
    @Binding var sliderValue: Double
    @State private var rotationAngle: Double = 0
    @State private var angularVelocity: Double = 0
    
    let thrusterForce: Double = 2.0
    let damping: Double = 0.98
    
    var body: some View {
        Rectangle()
            .frame(width: 200, height: 20)
            .rotationEffect(Angle(degrees: rotationAngle))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    updateRotation()
                }
            }
    }
    
    private func updateRotation() {
        let thrusterEffect = sliderValue - 0.5
        let torque = thrusterForce * thrusterEffect
        angularVelocity += torque
        angularVelocity *= damping
        rotationAngle += angularVelocity
    }
}



struct RotatingBarView_Previews: PreviewProvider {
    static var previews: some View {
        RotatingBarView()
    }
}
