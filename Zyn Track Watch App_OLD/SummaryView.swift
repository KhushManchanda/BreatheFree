import SwiftUI

struct SummaryView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Today's Total
                VStack(spacing: 4) {
                    Text("Today's Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(tracker.getTotalForDate(tracker.selectedDate))")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.top, 8)
                
                // Strength Breakdown
                VStack(spacing: 8) {
                    Text("Breakdown")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(ZynStrength.allCases, id: \.self) { strength in
                        HStack {
                            Text(strength.displayName)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("\(tracker.getCountForSelectedDate(strength))")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.secondary))
                        .cornerRadius(6)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    SummaryView()
}
