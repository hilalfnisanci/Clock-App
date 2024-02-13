//
//  AlarmView.swift
//  ClockApp
//
//  Created by Hilal on 21.12.2023.
//

import Foundation
import SwiftUI
import AVFoundation

struct Alarm: Identifiable {
    var id = UUID()
    var hours: Int
    var minutes: Int
    var time: String
    var days: [String]
    var isActive: Bool
}

class AlarmModel: ObservableObject {
    @Published var selectedHours: Int = 4
    @Published var selectedMinutes: Int = 15
    @Published var selectedTime: String = ""
    @Published var selectedDays: [String] = []
    @Published var alarms: [Alarm] = []
    @State private var showAlert = false
    
    var player: AVAudioPlayer?
    var timer: Timer?
    
    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "apple_alarm_clock", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
            
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = 0
            player.play()
            
            _ = 5.0
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopAlarmSound() {
        player?.stop()
    }
    
    func startAlarmTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkAlarms()
        }
    }
    
    func stopAlarmTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkAlarms() {
        let now = Calendar.current.dateComponents([.hour, .minute, .weekday], from: Date())
        var currentHour = now.hour ?? 0
        let currentMinute = now.minute ?? 0
        let currentWeekday = now.weekday ?? 1
        
        for alarm in alarms {
            if alarm.time == "AM" && currentHour < 12 {
                currentHour += 12
            } else if alarm.time == "PM" && currentHour >= 12 {
                currentHour -= 12
            }
                        
            if alarm.isActive && alarm.hours == currentHour && alarm.minutes == currentMinute && alarm.days.contains(dayString(from: currentWeekday)) {
                
                print("Alarm found! \(alarm.hours):\(alarm.minutes)")
                playAlarmSound()
            }
        }
    }
    
    private func dayString(from weekday: Int) -> String {
        switch weekday {
            case 1: return "Sun"
            case 2: return "Mon"
            case 3: return "Tue"
            case 4: return "Wed"
            case 5: return "Thu"
            case 6: return "Fri"
            case 7: return "Sat"
            default: return ""
        }
    }
}

struct AlarmView: View {
    @StateObject private var alarmModel = AlarmModel()
    @State private var isAddAlarmViewShown = false
    
    var body: some View {
        VStack {
            if isAddAlarmViewShown {
                AddAlarmView(alarmModel: alarmModel, goBackAction: { isAddAlarmViewShown = false })
            } else {
                AlarmMainView(alarmModel: alarmModel, startAction: { isAddAlarmViewShown = true })
            }
        }
        .onAppear {
            alarmModel.startAlarmTimer()
        }
    }
}

struct AlarmMainView: View {
    @ObservedObject var alarmModel: AlarmModel
    
    var startAction: () -> Void
    
    var body: some View {
        VStack {
            Text("ALARM")
                .font(.system(size: 25, weight: .regular, design: .default))
            
            Spacer().frame(height: 90)
            
            if alarmModel.alarms.isEmpty {
                Text("No alarms added yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(alarmModel.alarms.indices, id: \.self) { index in
                        let alarm = alarmModel.alarms[index]
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(alarm.hours):\(alarm.minutes) ")
                                    .font(.system(size: 30, weight: .medium)) +
                                Text("\(alarm.time)")
                                    .font(.system(size: 20, weight: .regular))
                                        
                                Spacer()
                                    
                                Toggle("", isOn: $alarmModel.alarms[index].isActive)
                                    .labelsHidden()
                                    .padding(.trailing)
                                    .toggleStyle(SwitchToggleStyle(tint: .black))
                                    .shadow(color: .black, radius: 4, x: 0, y: 2)
                            }
                                
                            HStack {
                                ForEach(alarm.days, id: \.self) { day in
                                    Text(day)
                                        .font(.system(size: 15, weight: .medium))
                                }
                            }
                            .padding(.leading)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer().frame(height: 90)
            
            Button(action: {
                startAction()
            }) {
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 100, height: 100)
                        .background(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.orange, lineWidth: 2)
                            .background(Color.white))
                        .cornerRadius(100)
                            
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 90, height: 90)
                        .background(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.black, lineWidth: 2)
                            .background(Color.white))
                        .cornerRadius(100)
            
                    Text("ADD")
                        .font(Font.custom("Inter", size: 20))
                        .foregroundColor(.black)
                }
            }
            .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
}

struct AddAlarmView: View {
    @ObservedObject var alarmModel: AlarmModel
    var goBackAction: () -> Void
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("ALARM")
                .font(.system(size: 25, weight: .regular, design: .default))
                .padding(.bottom, 60)
            
            HStack {
                VStack {
                    Picker("Selected Hours", selection: $alarmModel.selectedHours) {
                        ForEach(1...12, id: \.self) { selectedHours in
                            Text("\(selectedHours)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: 50, maxHeight: 180)
                }
                
                Divider().background(Color.black).frame(height: 180)

                VStack {
                    Picker("Selected Minutes", selection: $alarmModel.selectedMinutes) {
                        ForEach(1...59, id: \.self) { selectedMinutes in
                            Text("\(selectedMinutes)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: 50, maxHeight: 190)
                }
            }
            .padding(.bottom, 20)
            
            HStack {
                Button(action: {
                    alarmModel.selectedTime = "AM"
                }) {
                    Text("AM")
                        .font(alarmModel.selectedTime == "AM" ? .system(size: 16, weight: .bold) : .system(size: 16, weight: .regular))
                        .foregroundColor(alarmModel.selectedTime == "AM" ? .orange : .black)
                    }
                    .frame(maxWidth: 60)
                    .background(alarmModel.selectedTime == "AM" ? Color.white : Color.clear)
                    
                Button(action: {
                    alarmModel.selectedTime = "PM"
                }) {
                    Text("PM")
                        .font(alarmModel.selectedTime == "PM" ? .system(size: 16, weight: .bold) : .system(size: 16, weight: .regular))
                        .foregroundColor(alarmModel.selectedTime == "PM" ? .orange : .black)
                    }
                    .frame(maxWidth: 60)
                    .background(alarmModel.selectedTime == "PM" ? Color.white : Color.clear)
            }
            .padding(.bottom, 20)
                
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Button(action: {
                        if alarmModel.selectedDays.contains(day) {
                            alarmModel.selectedDays.removeAll(where: { $0 == day })
                        } else {
                            alarmModel.selectedDays.append(day)
                        }
                    })
                    {
                        Text(day)
                        .font(alarmModel.selectedDays.contains(day) ? .system(size: 16, weight: .bold) : .system(size: 16, weight: .regular))
                        .foregroundColor(alarmModel.selectedDays.contains(day) ? .orange : .black)
                    }
                    .frame(maxWidth: 35)
                    .id(UUID())
                }
            }
            .padding(.bottom, 30)
            
            Button(action: {
                saveAlarm()
            }) {
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 140, height: 60)
                        .background(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.orange, lineWidth: 2)
                            .background(Color.white))
                        .cornerRadius(80)
                            
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 130, height: 50)
                        .background(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.black, lineWidth: 2)
                            .background(Color.white))
                        .cornerRadius(80)
            
                    Text("SAVE")
                        .font(Font.custom("Inter", size: 20))
                        .foregroundColor(.black)
                }
            }
            .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Attention! To set an alarm, you must select both the hour, minute, day/days and time zone. Additionally, if you intend to add the same alarm again, please choose a different time."), dismissButton: .default(Text("Okey")))
        }
    }
    
    func saveAlarm() {
        let newAlarm = Alarm(hours: alarmModel.selectedHours,
            minutes: alarmModel.selectedMinutes,
            time: alarmModel.selectedTime,
            days: alarmModel.selectedDays,
            isActive: true)
        
        if !alarmModel.alarms.contains(where: {
            existingAlarm in
            return existingAlarm.hours == newAlarm.hours &&
                existingAlarm.minutes == newAlarm.minutes &&
                existingAlarm.time == newAlarm.time &&
                existingAlarm.days == newAlarm.days
        }) {
            print("Alarm added successfully!")
            print("New Alarm: \(newAlarm.hours):\(newAlarm.minutes) - \(newAlarm.time), Days: \(newAlarm.days)")

            if alarmModel.selectedTime.isEmpty && alarmModel.selectedDays.isEmpty {
                showAlert = true
            } else {
                alarmModel.alarms.append(newAlarm)
                alarmModel.selectedHours = 4
                alarmModel.selectedMinutes = 15
                alarmModel.selectedTime = ""
                alarmModel.selectedDays = []
                goBackAction()
            }
            
        } else {
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
