//
//  ThrusterFlameView.swift
//  SwiftyPID
//
//  Created by Tomer Zilbershtein on 4/21/23.
//

import SwiftUI


struct ThrusterFlameView: View {
    var size: CGSize
    var color: Color = Color.orange
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .frame(width: size.width, height: size.height)
    }
}
