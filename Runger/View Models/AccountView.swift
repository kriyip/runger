//
//  AccountView.swift
//  Runger
//
//  Created by Teena Bhatia on 22/4/24.
//

import SwiftUI

struct AccountView: View {
    @State private var topFastestRuns: [RunModel] = []

    var body: some View {
        NavigationView {
            VStack {
                List(topFastestRuns, id: \.self) { run in
                    if let runId = run.id {
                        Text("Run ID: \(runId.uuidString)")
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .onAppear {
                loadTopFastestRuns()
            }
        }
    }

    private func loadTopFastestRuns() {
        topFastestRuns = PersistenceController.shared.getTopFastestRuns()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
