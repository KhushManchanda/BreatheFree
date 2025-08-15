import SwiftUI
import Charts

struct VisualizationView: View {
    @ObservedObject var tracker: ZynTracker
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Selected Date Summary
                    VStack(spacing: 12) {
                        Text("Summary for \(DateFormatter.dayFormatter.string(from: tracker.selectedDate))")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack {
                            VStack {
                                Text("\(tracker.getTotalForDate(tracker.selectedDate))")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("Total Zyns")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text(DateFormatter.shortDayFormatter.string(from: tracker.selectedDate))
                                    .font(.headline)
                                    .fontWeight(.medium)
                                Text("Date")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Weekly Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Trend")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Chart(tracker.getWeeklyData(), id: \.0) { item in
                            BarMark(
                                x: .value("Day", DateFormatter.shortDayFormatter.string(from: item.0)),
                                y: .value("Count", item.1)
                            )
                            .foregroundStyle(Color.blue.gradient)
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Strength Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Strength Breakdown")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ForEach(tracker.counters) { counter in
                            HStack {
                                Circle()
                                    .fill(Color(counter.strength.color))
                                    .frame(width: 12, height: 12)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(counter.strength.displayName)
                                        .font(.body)
                                    
                                    Text("\(counter.strength.displayName) Zyn")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(getCountForSelectedDate(counter))")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text("Total: \(counter.totalCount)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Analytics")
        }
    }
    
    private func getCountForSelectedDate(_ counter: ZynCounter) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: tracker.selectedDate)
        return counter.entries.filter { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: startOfDay)
        }.reduce(0) { $0 + $1.count }
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let shortDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
}
