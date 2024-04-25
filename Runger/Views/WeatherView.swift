//
//  WeatherView.swift
//  Runger
//
//  Created by Teena Bhatia on 24/4/24.
//

import Foundation
import SwiftUI

struct WeatherWidgetView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("San Francisco")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Mostly Clear")
                        .font(.caption)
                }
                Spacer()
                Image(systemName: "sun.max.fill")
                    .renderingMode(.original)
                    .font(.largeTitle)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Text("44°")
                    .font(.system(size: 44, weight: .thin))
                Spacer()
                VStack(alignment: .leading) {
                    Text("H: 59°")
                        .font(.caption)
                    Text("L: 43°")
                        .font(.caption)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 200, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .foregroundColor(.white)
        .shadow(radius: 10)
    }
}

struct WeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetView()
    }
}
