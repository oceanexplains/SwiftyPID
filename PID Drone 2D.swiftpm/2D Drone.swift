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
    
    func applyForce(forceX: CGFloat, forceY: CGFloat) {
        velocity.x += forceX / mass
        velocity.y += (forceY - mass * gravity) / mass
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

struct DraggableTargetView: View {
    @Binding var targetPosition: CGPoint
    
    @State private var dragOffset: CGSize = CGSize.zero
    
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 40, height: 40)
            .offset(x: dragOffset.width, y: dragOffset.height)
            .position(x: targetPosition.x, y: targetPosition.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        targetPosition.x += value.translation.width
                        targetPosition.y += value.translation.height
                        dragOffset = CGSize.zero
                    }
            )
    }
}

struct ThrusterFlameView: View {
    var size: CGSize
    var color: Color = Color.orange
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .frame(width: size.width, height: size.height)
    }
}

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
            }), selectedController: $selectedController)
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
//struct SimulationView: View {
//    @ObservedObject var drone = Drone(position: CGPoint(x: 200, y: 300))
//    
//    @State private var targetPosition = CGPoint(x: 200, y: 100)
//    @State private var dt: CGFloat = 0.01
//    
//    private let pidControllerX = PIDController(kp: 0.5, ki: 0.1, kd: 0.05)
//    private let pidControllerY = PIDController(kp: 1.0, ki: 0.2, kd: 0.1)
//    private let pidControllerOrientation = PIDController(kp: 50, ki: 0.5, kd: 5)
//    
//    @State private var leftThrusterForce: CGFloat = 0
//    @State private var rightThrusterForce: CGFloat = 0
//
//    
//    var body: some View {
//        ZStack {
//            DraggableTargetView(targetPosition: $targetPosition)
////            DroneView(drone: drone)
//            DroneView(drone: drone, leftThrusterForce: $leftThrusterForce, rightThrusterForce: $rightThrusterForce)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.gray.opacity(0.5))
//        .edgesIgnoringSafeArea(.all)
//        .onAppear {
//            Timer.scheduledTimer(withTimeInterval: Double(dt), repeats: true) { _ in
//                let controlActionX = pidControllerX.updateControlAction(target: targetPosition.x, current: drone.position.x, dt: dt)
//                let controlActionY = pidControllerY.updateControlAction(target: targetPosition.y, current: drone.position.y, dt: dt)
//                let controlActionOrientation = pidControllerOrientation.updateControlAction(target: 0, current: drone.angle, dt: dt)
//                
//                drone.applyForce(forceX: controlActionX, forceY: controlActionY)
//                drone.applyTorque(torque: controlActionOrientation)
//                drone.update(dt: dt)
//            }
//        }
//    }
//}


//struct DroneView: View {
//    @ObservedObject var drone: Drone
//    
//    var body: some View {
//        Rectangle()
//            .frame(width: 200, height: 20)
//            .position(x: drone.position.x, y: drone.position.y)
//            .rotationEffect(Angle(radians: Double(drone.angle)))
//    }
//}

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





struct ContentView: View {
    var body: some View {
        SimulationView()
    }
}

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
                Slider(value: $pidController.kp, in: 0...100)
                
                Text("Ki: \(pidController.ki, specifier: "%.2f")")
                Slider(value: $pidController.ki, in: 0...100)
                
                Text("Kd: \(pidController.kd, specifier: "%.2f")")
                Slider(value: $pidController.kd, in: 0...100)
            }
            .padding(.horizontal)
        }
    }
}

