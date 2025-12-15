import SwiftUI

struct ContentView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(ZynStrength.allCases, id: \.self) { strength in
                        NavigationLink(destination: WatchCounterView(tracker: tracker, strength: strength)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(strength.displayName)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    Text("\(tracker.getCountForSelectedDate(strength)) pouches")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "chevron.right.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(strength.color))
                            .cornerRadius(16)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Zyn Tracker")
        }
    }
    }
}

#Preview {
    ContentView()
}
