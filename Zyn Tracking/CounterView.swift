import SwiftUI

struct CounterView: View {
    @ObservedObject var tracker: ZynTracker
    let counter: ZynCounter
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(counter.strength.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(counter.strength.color))
                    
                    Text("\(counter.strength.displayName) Zyn")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(getCountForSelectedDate())")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(counter.strength.color))
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    if getCountForSelectedDate() > 0 {
                        tracker.addEntryForDate(for: counter.strength, count: -1, date: tracker.selectedDate)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .disabled(getCountForSelectedDate() <= 0)
                
                Button(action: {
                    tracker.addEntryForDate(for: counter.strength, count: 1, date: tracker.selectedDate)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(counter.totalCount)")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func getCountForSelectedDate() -> Int {
        let startOfDay = Calendar.current.startOfDay(for: tracker.selectedDate)
        return counter.entries.filter { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: startOfDay)
        }.reduce(0) { $0 + $1.count }
    }
}
