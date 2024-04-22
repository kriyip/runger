//
//  AccountView.swift
//  Runger
//
//  Created by Teena Bhatia on 22/4/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                //  GraphView()
                //            List {
                //                NavigationLink(destination: SavedRunView()) {
                //                    Text("Run on [Date]")
                //                }
                //            }
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
