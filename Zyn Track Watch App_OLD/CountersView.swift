import SwiftUI

struct CountersView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(ZynStrength.allCases, id: \.self) { strength in
                    CounterRow(strength: strength, tracker: tracker)
                }
            }
            .padding(.horizontal, 8)
        }
        .navigationTitle("Counters")
    }
}

struct CounterRow: View {
    let strength: ZynStrength
    @ObservedObject var tracker: ZynTracker
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(strength.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(tracker.getCountForSelectedDate(strength))")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Button(action: {
                    if tracker.getCountForSelectedDate(strength) > 0 {
                        tracker.addEntryForDate(for: strength, count: -1, date: tracker.selectedDate)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .disabled(tracker.getCountForSelectedDate(strength) <= 0)
                
                Button(action: {
                    tracker.addEntryForDate(for: strength, count: 1, date: tracker.selectedDate)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondary))
        .cornerRadius(8)
    }
}

#Preview {
    CountersView()
}
