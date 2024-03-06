//
//  ContentView.swift
//  ClockApp
//
//  Created by Hilal on 19.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var screenSize: CGRect = UIScreen.main.bounds
    @FetchRequest(entity: Alarm.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.hours, ascending: true)]) var alarms: FetchedResults<Alarm>

    var body: some View {

        TabView(selection: $selectedTab) {
            AnalogClockView()
                .tabItem {
                    Text("Clock")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
                .tag(0)
            
            AlarmView()
                .tabItem {
                    Text("Alarm")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
                .tag(1)
            
            CronometerView()
                .tabItem {
                    Text("Cronometer")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
                .tag(2)
            
            TimerView()
                .tabItem {
                    Text("Timer")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
                .tag(3)
        }
        .accentColor(.black)
        
    }
}

#Preview {
    ContentView()
}
