import Foundation
import WatchConnectivity

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

// MARK: - ZynTracker with WatchConnectivity
class ZynTracker: NSObject, ObservableObject, WCSessionDelegate {
    @Published var counters: [ZynCounter] = []
    @Published var selectedDate: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let countersKey = "ZynCounters"
    
    override init() {
        super.init()
        loadCounters()
        setupWatchConnectivity()
        
        // Initialize with default counters if empty
        if counters.isEmpty {
            counters = ZynStrength.allCases.map { strength in
                ZynCounter(strength: strength, entries: [])
            }
        }
    }
    
    // MARK: - WatchConnectivity Setup
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WatchConnectivity activation failed: \(error.localizedDescription)")
        } else {
            print("WatchConnectivity activated successfully")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WatchConnectivity session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WatchConnectivity session deactivated")
        // Reactivate for future use
        WCSession.default.activate()
    }
    #endif
    
    // MARK: - Data Synchronization
    func syncDataToWatch() {
        guard WCSession.default.isReachable else { return }
        
        let data = try? JSONEncoder().encode(counters)
        let message = ["counters": data?.base64EncodedString() ?? ""]
        
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Failed to sync data to watch: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let countersData = message["counters"] as? String,
               let data = Data(base64Encoded: countersData),
               let newCounters = try? JSONDecoder().decode([ZynCounter].self, from: data) {
                self.counters = newCounters
                self.saveCounters()
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
        syncDataToWatch()
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
