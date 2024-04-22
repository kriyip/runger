//
//  SavedRunView.swift
//  Runger
//
//  Created by Deepika Kannan on 4/21/24.
//

import SwiftUI
import CoreData

struct SavedRunView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RunModel.startTime, ascending: false)],
        animation: .default)
    private var runs: FetchedResults<RunModel>

    var body: some View {
        List {
            ForEach(runs, id: \.self) { run in
                VStack(alignment: .leading) {
                    Text("Run on \(run.startTime!, formatter: itemFormatter)")
                    Text("Duration: \(run.endTime!.timeIntervalSince(run.startTime!)) seconds")
                    // Add more details as necessary
                }
            }
            .onDelete(perform: deleteRuns)
        }
    }

    private func deleteRuns(offsets: IndexSet) {
        withAnimation {
            offsets.map { runs[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



