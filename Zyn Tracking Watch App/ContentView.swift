import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CountersView()
            SummaryView()
            QuickAddView()
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    ContentView()
}
