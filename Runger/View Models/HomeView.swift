//
//  HomeView.swift
//  Runger
//
//  Created by Teena Bhatia on 22/4/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
               // WeeklySnapshotView()
              //  WeatherView()
              //  PastActivityView()
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

