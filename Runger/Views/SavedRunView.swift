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
        entity: RunModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RunModel.startTime, ascending: false)],
        animation: .default)
    private var runs: FetchedResults<RunModel>

    var body: some View {
        List {
            ForEach(runs, id: \.self) { run in
                VStack(alignment: .leading) {
                    Text("Run on: \(String(describing: run.startTime)).formatted(.number.precision(.fractionLength(2))))")

                    if let endTime = run.endTime, let startTime = run.startTime {
                        Text("Duration: \((endTime.timeIntervalSince(startTime) / 60).formatted(.number.precision(.fractionLength(2)))) minutes")
                    }
                    Text("Distance: \(run.totalDistance, specifier: "%.2f") m")
                    Text("Duration: \(run.totalDuration, specifier: "%.2f)") sec")
                    Text("Average Pace: \(run.averagePace, specifier: "%.2f") m/s")
                    if let id = run.id {
                        Text("Run ID: \(id.uuidString)")
                    }
                }
            }
            .onDelete(perform: deleteRuns)
        }
    }

    private func deleteRuns(offsets: IndexSet) {
        withAnimation {
            offsets.map { runs[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error saving context after delete: \(error)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct SavedRunView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRunView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



