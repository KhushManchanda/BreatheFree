import SwiftUI

struct QuickAddView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Quick Add")
                .font(.headline)
                .padding(.top, 8)
            
            ForEach(ZynStrength.allCases, id: \.self) { strength in
                Button(action: {
                    tracker.addEntryForDate(for: strength, count: 1, date: tracker.selectedDate)
                }) {
                    HStack {
                        Text(strength.displayName)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("+1")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    QuickAddView()
}
