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
                
                Text("\(tracker.getCountForSelectedDate(strength)) today")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Button(action: {
                    tracker.addEntryForDate(for: strength, count: 1, date: tracker.selectedDate)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    let currentCount = tracker.getCountForSelectedDate(strength)
                    if currentCount > 0 {
                        tracker.addEntryForDate(for: strength, count: -1, date: tracker.selectedDate)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(tracker.getCountForSelectedDate(strength) <= 0)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    CountersView()
}
