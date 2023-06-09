//
//  DraggableTargetView.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI
struct DraggableTargetView: View {
    @Binding var targetPosition: CGPoint
    
    @State private var dragOffset: CGSize = CGSize.zero
    
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 40, height: 40)
            .position(x: targetPosition.x + dragOffset.width, y: targetPosition.y + dragOffset.height)
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
