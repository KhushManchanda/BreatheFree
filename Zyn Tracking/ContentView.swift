//
//  ContentView.swift
//  Zyn Tracking
//
//  Created by Khush Manchanda on 8/13/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tracker = ZynTracker()
    
    var body: some View {
        TabView {
            // Counters Tab
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Date Selector Header
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: {
                                    tracker.goToPreviousDay()
                                }) {
                                    Image(systemName: "chevron.left.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text(DateFormatter.dayFormatter.string(from: tracker.selectedDate))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    
                                    if Calendar.current.isDateInToday(tracker.selectedDate) {
                                        Text("Today")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                            .fontWeight(.medium)
                                    } else if Calendar.current.isDateInYesterday(tracker.selectedDate) {
                                        Text("Yesterday")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                            .fontWeight(.medium)
                                    } else if Calendar.current.isDateInTomorrow(tracker.selectedDate) {
                                        Text("Tomorrow")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    Button(action: {
                                        tracker.goToToday()
                                    }) {
                                        Text("Today")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    
                                    Button(action: {
                                        tracker.goToNextDay()
                                    }) {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                    }
                                    .disabled(Calendar.current.isDateInToday(tracker.selectedDate))
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Daily Total Header
                        VStack(spacing: 8) {
                            Text("Total for \(DateFormatter.shortDayFormatter.string(from: tracker.selectedDate))")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text("\(tracker.getTotalForDate(tracker.selectedDate))")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        // Individual Counters
                        ForEach(tracker.counters) { counter in
                            CounterView(tracker: tracker, counter: counter)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Zyn Tracker")
            }
            .tabItem {
                Image(systemName: "number.circle.fill")
                Text("Counters")
            }
            
            // Analytics Tab
            VisualizationView(tracker: tracker)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
