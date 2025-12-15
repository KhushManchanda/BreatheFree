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
                ZStack {
                    Color(UIColor.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Date Selector Header
                            DateHeader(tracker: tracker)
                            
                            // Daily Total Hero Card
                            DailyTotalHero(tracker: tracker)
                            
                            // Individual Counters
                            VStack(spacing: 16) {
                                ForEach(tracker.counters) { counter in
                                    StrengthCard(tracker: tracker, counter: counter)
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationBarHidden(true)
                }
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

// MARK: - Subviews

struct DateHeader: View {
    @ObservedObject var tracker: ZynTracker
    
    var body: some View {
        HStack {
            Button(action: { tracker.goToPreviousDay() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(DateFormatter.dayFormatter.string(from: tracker.selectedDate).uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                HStack(alignment: .lastTextBaseline) {
                    if Calendar.current.isDateInToday(tracker.selectedDate) {
                        Text("Today")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else if Calendar.current.isDateInYesterday(tracker.selectedDate) {
                        Text("Yesterday")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else if Calendar.current.isDateInTomorrow(tracker.selectedDate) {
                        Text("Tomorrow")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else {
                        Text(tracker.selectedDate, style: .date)
                             .font(.title2)
                             .fontWeight(.bold)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                if !Calendar.current.isDateInToday(tracker.selectedDate) {
                    Button(action: { tracker.goToToday() }) {
                        Text("TODAY")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
                
                Button(action: { tracker.goToNextDay() }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Calendar.current.isDateInToday(tracker.selectedDate) ? .gray.opacity(0.3) : .primary)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .disabled(Calendar.current.isDateInToday(tracker.selectedDate))
            }
        }
        .padding(.vertical, 8)
    }
}

struct DailyTotalHero: View {
    @ObservedObject var tracker: ZynTracker
    
    var totalCount: Int {
        tracker.getTotalForDate(tracker.selectedDate)
    }
    
    var gradientColors: [Color] {
        if totalCount < 10 {
            return [Color.green, Color.green.opacity(0.8)]
        } else if totalCount < 20 {
            return [Color.orange, Color.orange.opacity(0.8)]
        } else {
            return [Color.red, Color.red.opacity(0.8)]
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("TOTAL INTAKE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.8))
                .tracking(1.5)
            
            Text("\(totalCount)")
                .font(.system(size: 72, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            Text("POUCHES")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: gradientColors.first!.opacity(0.4), radius: 15, x: 0, y: 10)
    }
}

struct StrengthCard: View {
    @ObservedObject var tracker: ZynTracker
    let counter: ZynCounter
    
    var count: Int {
        tracker.getCountForSelectedDate(counter.strength)
    }
    
    var body: some View {
        HStack {
            // Strength Indicator
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(counter.strength.color))
                    .frame(width: 12, height: 12)
                    .shadow(color: Color(counter.strength.color).opacity(0.5), radius: 4, x: 0, y: 0)
                
                Text(counter.strength.displayName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Stepper and Count
            HStack(spacing: 20) {
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    tracker.addEntryForDate(for: counter.strength, count: -1, date: tracker.selectedDate)
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(count > 0 ? .red : .gray)
                        .frame(width: 40, height: 40)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(count == 0)
                
                Text("\(count)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(minWidth: 40)
                    .foregroundColor(.primary)
                
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    tracker.addEntryForDate(for: counter.strength, count: 1, date: tracker.selectedDate)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

#Preview {
    ContentView()
}
