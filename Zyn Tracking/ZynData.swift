import Foundation

// MARK: - Shared Data Models
struct ZynEntry: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let count: Int
    let strength: ZynStrength
}

enum ZynStrength: String, CaseIterable, Codable {
    case threeMG = "3mg"
    case sixMG = "6mg"
    case nineMG = "9mg"

    var displayName: String {
        return self.rawValue
    }

    var color: String {
        switch self {
        case .threeMG:
            return "green"
        case .sixMG:
            return "blue"
        case .nineMG:
            return "red"
        }
    }
}

struct ZynCounter: Identifiable, Codable {
    var id = UUID()
    let strength: ZynStrength
    var entries: [ZynEntry]

    var totalCount: Int {
        return entries.reduce(0) { $0 + $1.count }
    }
}

// MARK: - ZynTracker
class ZynTracker: ObservableObject {
    @Published var counters: [ZynCounter] = []
    @Published var selectedDate: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let countersKey = "ZynCounters"
    
    init() {
        loadCounters()
        
        // Initialize with default counters if empty
        if counters.isEmpty {
            counters = ZynStrength.allCases.map { strength in
                ZynCounter(strength: strength, entries: [])
            }
        }
    }
    
    // MARK: - Data Management
    func addEntryForDate(for strength: ZynStrength, count: Int, date: Date) {
        let entry = ZynEntry(date: date, count: count, strength: strength)
        
        if let index = counters.firstIndex(where: { $0.strength == strength }) {
            counters[index].entries.append(entry)
        }
        
        saveCounters()
        
        saveCounters()
    }
    
    func getCountForSelectedDate(_ strength: ZynStrength) -> Int {
        let calendar = Calendar.current
        return counters
            .first { $0.strength == strength }?
            .entries
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { $0 + $1.count } ?? 0
    }
    
    func getTotalForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return counters.reduce(0) { total, counter in
            total + counter.entries
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.count }
        }
    }
    
    func getEntriesForDate(_ date: Date) -> [ZynEntry] {
        let calendar = Calendar.current
        return counters.flatMap { counter in
            counter.entries.filter { calendar.isDate($0.date, inSameDayAs: date) }
        }
    }
    
    // MARK: - Date Navigation
    func goToPreviousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func goToNextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func goToToday() {
        selectedDate = Date()
    }
    
    // MARK: - Weekly Data for Charts
    func getWeeklyData() -> [(Date, Int)] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        
        var weeklyData: [(Date, Int)] = []
        
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: startOfWeek) {
                let total = getEntriesForDate(date).reduce(0) { $0 + $1.count }
                weeklyData.append((date, total))
            }
        }
        
        return weeklyData
    }
    
    // MARK: - Persistence
    private func saveCounters() {
        if let data = try? JSONEncoder().encode(counters) {
            userDefaults.set(data, forKey: countersKey)
        }
    }
    
    private func loadCounters() {
        if let data = userDefaults.data(forKey: countersKey),
           let loadedCounters = try? JSONDecoder().decode([ZynCounter].self, from: data) {
            counters = loadedCounters
        }
    }
}
