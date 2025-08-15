# 🍎 Apple Watch Setup Guide for Zyn Tracking

## **Overview**
This guide will help you add Apple Watch support to your Zyn Tracking app. The Watch app will have the same functionality as your iPhone app, with data synchronization between devices.

## **Features Included**
- ✅ **Counters View**: Individual counters for 3mg, 6mg, and 9mg Zyn
- ✅ **Quick Add View**: Fast one-tap Zyn tracking
- ✅ **Summary View**: Daily totals and breakdown by strength
- ✅ **Data Synchronization**: Real-time sync between iPhone and Apple Watch
- ✅ **Persistent Storage**: Data saved locally on both devices

## **Step 1: Add Apple Watch Target in Xcode**

1. **Open Xcode** and your "Zyn Tracking" project
2. **Select your project** in the Project Navigator (blue icon)
3. **Click the "+" button** at the bottom of the targets list
4. **Choose "watchOS" → "Watch App"**
5. **Configure the target:**
   - Product Name: `Zyn Tracking Watch App`
   - Bundle ID: `com.yourname.ZynTracking.watchkitapp` (adjust as needed)
   - Language: Swift
   - Interface: SwiftUI
   - Include Notification Scene: ✅ (checked)

## **Step 2: Add Shared Files to Both Targets**

1. **Right-click your project** → "Add Files to 'Zyn Tracking'"
2. **Select "Shared/ZynData.swift"**
3. **Check both targets:**
   - ✅ "Zyn Tracking" (iPhone)
   - ✅ "Zyn Tracking Watch App" (Watch)

## **Step 3: Add Watch App Files**

1. **Right-click your project** → "Add Files to 'Zyn Tracking'"
2. **Select all Watch app Swift files:**
   - `Zyn Tracking Watch App/Zyn_Tracking_Watch_App.swift`
   - `Zyn Tracking Watch App/ContentView.swift`
   - `Zyn Tracking Watch App/CountersView.swift`
   - `Zyn Tracking Watch App/QuickAddView.swift`
   - `Zyn Tracking Watch App/SummaryView.swift`
3. **Check only Watch target:**
   - ❌ "Zyn Tracking" (iPhone)
   - ✅ "Zyn Tracking Watch App" (Watch)

## **Step 4: Add Watch App Configuration Files**

1. **Right-click your project** → "Add Files to 'Zyn Tracking'"
2. **Select these configuration files:**
   - `Zyn Tracking Watch App/Info.plist`
   - `Zyn Tracking Watch App/Assets.xcassets/`
   - `Zyn Tracking Watch App/Preview Content/`
3. **Check only Watch target:**
   - ❌ "Zyn Tracking" (iPhone)
   - ✅ "Zyn Tracking Watch App" (Watch)

## **Step 5: Configure Bundle Identifiers**

1. **Select your project** in Project Navigator
2. **Select the Watch app target**
3. **Go to "Signing & Capabilities" tab**
4. **Ensure bundle identifier follows pattern:**
   - iPhone: `com.yourname.ZynTracking`
   - Watch: `com.yourname.ZynTracking.watchkitapp`

## **Step 6: Configure Deployment Targets**

1. **Select your project** in Project Navigator
2. **Select the Watch app target**
3. **Go to "General" tab**
4. **Set "Deployment Target" to match your iPhone app**
   - Recommended: iOS 18.2+ / watchOS 11.0+

## **Step 7: Build and Test**

1. **Select "Zyn Tracking Watch App" target**
2. **Choose Apple Watch simulator** (e.g., Apple Watch Series 9)
3. **Click Build button** (▶️)
4. **Verify the Watch app builds successfully**

## **Step 8: Test Data Synchronization**

1. **Run iPhone app** in iPhone simulator
2. **Run Watch app** in Apple Watch simulator
3. **Add some Zyn entries** in either app
4. **Verify data appears** in both apps

## **File Structure After Setup**

```
Zyn Tracking/
├── Shared/
│   └── ZynData.swift (shared between iPhone and Watch)
├── Zyn Tracking Watch App/
│   ├── Zyn_Tracking_Watch_App.swift
│   ├── ContentView.swift
│   ├── CountersView.swift
│   ├── QuickAddView.swift
│   ├── SummaryView.swift
│   ├── Info.plist
│   └── Assets.xcassets/
└── [iPhone app files...]
```

## **Troubleshooting**

### **Build Errors**
- **"No such module 'WatchConnectivity'"**: Ensure `ZynData.swift` is added to both targets
- **"Multiple targets produce..."**: Check file membership in target settings
- **"Bundle identifier conflicts"**: Verify unique bundle IDs for iPhone and Watch

### **Runtime Issues**
- **Data not syncing**: Check WatchConnectivity session activation
- **App crashes**: Verify all required files are added to Watch target
- **UI not displaying**: Check SwiftUI preview compatibility

### **Common Solutions**
1. **Clean Build Folder**: Product → Clean Build Folder
2. **Reset Simulators**: Device → Erase All Content and Settings
3. **Check Target Membership**: Select file → File Inspector → Target Membership

## **Next Steps**

After successful setup:
1. **Customize Watch app icon** in Assets.xcassets
2. **Add complications** for quick data access
3. **Implement notifications** for daily reminders
4. **Add haptic feedback** for better user experience

## **Support**

If you encounter issues:
1. Check Xcode console for error messages
2. Verify all files are properly added to targets
3. Ensure bundle identifiers are unique
4. Clean and rebuild the project

---

**🎉 Congratulations!** Your Zyn Tracking app now supports Apple Watch with full data synchronization!
