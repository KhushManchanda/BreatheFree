import SwiftUI

struct WatchCounterView: View {
    @ObservedObject var tracker: ZynTracker
    let strength: ZynStrength
    
    var body: some View {
    @State private var isPulsing = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Header
            Text(strength.displayName)
                .font(.headline)
                .foregroundColor(Color(strength.color))
            
            // Animated Counter
            ZStack {
                Circle()
                    .fill(Color(strength.color).opacity(0.2))
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                    .opacity(isPulsing ? 0.0 : 1.0)
                    .frame(width: 80, height: 80)
                
                Text("\(tracker.getCountForSelectedDate(strength))")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(height: 90)
            
            // Controls
            HStack(spacing: 15) {
                Button(action: {
                    WKInterfaceDevice.current().play(.click)
                    tracker.addEntryForDate(for: strength, count: -1, date: Date())
                }) {
                    Image(systemName: "minus")
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.2))
                        .clipShape(Circle())
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    WKInterfaceDevice.current().play(.success)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPulsing = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPulsing = false
                    }
                    tracker.addEntryForDate(for: strength, count: 1, date: Date())
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    }
}

#Preview {
    WatchCounterView(tracker: ZynTracker(), strength: .sixMG)
}
