//
//  GraphView.swift
//  Runger
//
//  Created by Teena Bhatia on 25/4/24.
//

import Foundation
import SwiftUI


struct GraphDataPoint {
    var date: Date
    var value: Double
}

struct GraphView: View {
    var dataPoints: [GraphDataPoint]
    
    private var normalizedDataPoints: [GraphDataPoint] {
        guard let max = dataPoints.map({ $0.value }).max() else { return [] }
        return dataPoints.map { GraphDataPoint(date: $0.date, value: $0.value / max) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Path for the data points
                Path { path in
                    for (index, dataPoint) in normalizedDataPoints.enumerated() {
                        let xPosition = geometry.size.width / CGFloat(normalizedDataPoints.count) * CGFloat(index)
                        let yPosition = (1 - dataPoint.value) * (geometry.size.height - 30)  // Leave space for labels
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Axes
                // Y-axis
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 0))
                    path.addLine(to: CGPoint(x: 15, y: geometry.size.height - 30))
                }
                .stroke(Color.black, lineWidth: 1)
                
                // X-axis
                Path { path in
                    path.move(to: CGPoint(x: 15, y: geometry.size.height - 30))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - 30))
                }
                .stroke(Color.black, lineWidth: 1)
                
                // Labels
                Text("Meters")
                    .font(.caption)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -19, y:  -7)
                
                Text("Date")
                    .font(.caption)
                    .offset(x: 160, y: 80)
            }
        }
        .padding([.top, .leading, .trailing])
    }
}

// For the preview
struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(dataPoints: [
            GraphDataPoint(date: Date().addingTimeInterval(-100000), value: 5),
            GraphDataPoint(date: Date().addingTimeInterval(-80000), value: 10),
            GraphDataPoint(date: Date().addingTimeInterval(-60000), value: 5)
        ])
        .frame(height: 200)
        .border(Color.gray, width: 1)
    }
}

