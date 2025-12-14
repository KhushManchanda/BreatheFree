import SwiftUI

struct ContentView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        NavigationView {
            List(ZynStrength.allCases, id: \.self) { strength in
                NavigationLink(destination: WatchCounterView(tracker: tracker, strength: strength)) {
                    HStack {
                        Circle()
                            .fill(Color(strength.color))
                            .frame(width: 12, height: 12)
                        Text(strength.displayName)
                            .font(.headline)
                        Spacer()
                        Text("\(tracker.getCountForSelectedDate(strength))")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Zyn Tracker")
        }
    }
}

#Preview {
    ContentView()
}
