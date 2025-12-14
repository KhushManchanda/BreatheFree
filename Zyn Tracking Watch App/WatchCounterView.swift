import SwiftUI

struct WatchCounterView: View {
    @ObservedObject var tracker: ZynTracker
    let strength: ZynStrength
    
    var body: some View {
        VStack(spacing: 20) {
            Text(strength.displayName)
                .font(.headline)
                .foregroundColor(Color(strength.color))
            
            Text("\(tracker.getCountForSelectedDate(strength))")
                .font(.system(size: 40, weight: .bold, design: .rounded))
            
            HStack(spacing: 20) {
                Button(action: {
                    tracker.addEntryForDate(for: strength, count: -1, date: Date())
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    tracker.addEntryForDate(for: strength, count: 1, date: Date())
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle(strength.displayName)
    }
}

#Preview {
    WatchCounterView(tracker: ZynTracker(), strength: .sixMG)
}
