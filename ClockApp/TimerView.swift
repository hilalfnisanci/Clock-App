//
//  TimerView.swift
//  ClockApp
//
//  Created by Hilal on 21.12.2023.
//

import Foundation
import SwiftUI
import AVKit

class TimerModel: ObservableObject {
    @Published var selectedHours: Int = 0
    @Published var selectedMinutes: Int = 0
    @Published var selectedSeconds: Int = 0
}

struct TimerView: View {
    @StateObject private var timerModel = TimerModel()
    @State private var isTimerOnViewShown = false

    var body: some View {
        VStack {
            if isTimerOnViewShown {
                TimerOnView(timerModel: timerModel, goBackAction: { isTimerOnViewShown = false })
            } else {
                TimerMainView(timerModel: timerModel, startAction: { isTimerOnViewShown = true })
            }
        }
    }
}

struct TimerMainView: View {
    @ObservedObject var timerModel: TimerModel
    @State private var timerElapsed: TimeInterval = 0
    @State private var timerOn: Bool = true

    var startAction: () -> Void

    var body: some View {
        VStack {
            Text("TIMER")
                .font(.system(size: 25, weight: .regular, design: .default))
            
            Spacer().frame(height: 90)
            
            HStack {
                VStack {
                    Text("Hours")
                        .font(.system(size: 18, weight: .medium, design: .default))
                    Picker("Selected Hours", selection: $timerModel.selectedHours) {
                        ForEach(0...9, id: \.self) { selectedHours in
                            Text("\(selectedHours)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame( maxHeight: 135)
                }
                
                VStack {
                    Text("Minutes")
                        .font(.system(size: 18, weight: .medium, design: .default))
                    Picker("Selected Minutes", selection: $timerModel.selectedMinutes) {
                        ForEach(0...59, id: \.self) { selectedMinutes in
                            Text("\(selectedMinutes)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame( maxHeight: 135)
                }
                
                VStack {
                    Text("Seconds")
                        .font(.system(size: 18, weight: .medium, design: .default))
                    Picker("Selected Seconds", selection: $timerModel.selectedSeconds) {
                        ForEach(0...59, id: \.self) { selectedSeconds in
                            Text("\(selectedSeconds)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame( maxHeight: 135)
                }
            }
            Spacer().frame(height: 90)
            Button(action: {
                timerOn = true
                startAction()
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
            
                    Text("START")
                        .font(Font.custom("Inter", size: 20))
                        .foregroundColor(.black)
                }
            }
            .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
}

struct TimerOnView: View {
    @ObservedObject var timerModel: TimerModel
    @State private var timerElapsed: TimeInterval = 0
    @State private var timerOn: Bool = true
    @State private var completionTime: String = ""
    @State private var audioPlayer: AVAudioPlayer?

    var goBackAction: () -> Void

    var body: some View {
        VStack {
            Text("TIMER")
                .font(.system(size: 25, weight: .regular, design: .default))
            
            Spacer().frame(height: 90)
            
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(1.0 - timerElapsed / (TimeInterval(timerModel.selectedHours * 3600 + timerModel.selectedMinutes * 60 + timerModel.selectedSeconds))))
                        .stroke(Color.orange, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(formattedTime())")
                        .font(.system(size: 30, weight: .light, design: .default))
                        .onAppear {
                            startTimer()
                        }
                    
                    let selectedTimeInterval = TimeInterval(timerModel.selectedHours * 3600 + timerModel.selectedMinutes * 60 + timerModel.selectedSeconds)

                    if timerElapsed >= TimeInterval(timerModel.selectedHours * 3600 + timerModel.selectedMinutes * 60 + timerModel.selectedSeconds) {
                        Text("Time's Up!")
                            .foregroundColor(.orange)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .offset(y: 80)
                    }
                    else{
                        let currentDate = Date()
                        let completionDate = Calendar.current.date(byAdding: .second, value: Int(selectedTimeInterval - timerElapsed), to: currentDate) ?? currentDate

                        let completionTime = timeFormatAmPm(from: completionDate)
                        
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            
                            Text("\(completionTime)")
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .regular, design: .default))
                        }
                        .offset(y: 80)
                    }
                }
                Spacer().frame(height: 90)
                HStack {
                    Button(action: goBackAction) {
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
                    
                            Text("CANCEL")
                                .font(Font.custom("Inter", size: 20))
                                .foregroundColor(.black)
                        }
                    }
                    .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
                    
                    Button(action: stopBtnAction) {
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
                                    .background(timerOn ? Color.orange.opacity(0.4) : Color.orange.opacity(0.2)))
                                .cornerRadius(80)
                    
                            Text(timerOn ? "STOP" : "CONTINUE")
                                .font(Font.custom("Inter", size: 20))
                                .foregroundColor(.black)
                        }
                    }
                    .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
                    
                }
            }
        }
    }
    
    // Alarm çalma fonksiyonu
    private func playAlarm() {
        guard let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing alarm sound: \(error.localizedDescription)")
        }
    }
    
    func timeFormatAmPm(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // AM/PM formatı
        return dateFormatter.string(from: date)
    }
    
    func formattedTime() -> String {
        let remainingTime = TimeInterval(timerModel.selectedHours * 3600 + timerModel.selectedMinutes * 60 + timerModel.selectedSeconds) - timerElapsed
        
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func startTimer() {
        let totalSeconds = timerModel.selectedHours * 3600 + timerModel.selectedMinutes * 60 + timerModel.selectedSeconds
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if timerElapsed < TimeInterval(totalSeconds) && timerOn{
                timerElapsed += 0.5
            } else {
                timer.invalidate()
                // Timer tamamlandığında buraya gelebilirsin, istediğin başka bir şeyi yapabilirsin.
            }
        }
    }
    
    private func stopBtnAction() {
        if timerOn {
            timerOn = false
        } else {
            timerOn = true
            startTimer()
        }
    }
}

#Preview {
    ContentView()
}
