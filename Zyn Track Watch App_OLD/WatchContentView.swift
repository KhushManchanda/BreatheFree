//
//  ContentView.swift
//  Zyn Track Watch App
//
//  Created by Khush Manchanda on 8/14/25.
//

import SwiftUI

struct WatchContentView: View {
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
    WatchContentView()
}
