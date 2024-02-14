//
//  AnalogClockView.swift
//  ClockApp
//
//  Created by Hilal on 21.12.2023.
//

import Foundation
import SwiftUI

struct AnalogClockView: View {
    @State private var currentTime = Date()
    @State private var hourHandAngle: Double = 0
    @State private var minuteHandAngle: Double = 0
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer().frame(height: 78)
                    Text("CLOCK")
                        .font(.system(size: 25, weight: .regular, design: .default))

                    Spacer().frame(height: 50)
                        
                    Circle()
                        .frame(width: 230, height: 230)
                        .foregroundColor(.black)
                        .overlay(
                            ForEach(0..<12, id: \.self) { index in
                                if index == 0 {
                                    Text("12")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                        .foregroundColor(.white)
                                        .offset(x: 0, y: -90)

                                } else if index == 6 {
                                    Text("\(index)")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                        .foregroundColor(.white)
                                        .offset(x: 0, y: 90)

                                } else if index == 3 || index == 9 {
                                    Text("\(index)")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                        .foregroundColor(.white)
                                        .offset(x: sin(Double(index) * .pi / 6) * 90, y: -cos(Double(index) * .pi / 6) * 90)
                                } else {
                                    Rectangle()
                                        .frame(width: 2, height: 10)
                                        .foregroundColor(.white)
                                        .offset(y: -90)
                                        .rotationEffect(.degrees(Double(index) * 30))
                                }
                            }
                            
                        )
                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                    
                    Spacer()
                    
                    Text("World Clock")
                        .font(.system(size: 25, weight: .semibold, design: .default))
                        .frame(maxWidth: 363, alignment: .leading)
                    
                    CityListView(currentTime: $currentTime)
                        .padding(.top, 50)

                    Spacer()
                }
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 80)
                
                let hourHandLength: CGFloat = 20
                let minuteHandLength: CGFloat = 30
                let handCenterX = geometry.size.width / 2
                let handCenterY = geometry.size.height / 2 - 80

                Rectangle()
                    .frame(width: 2, height: 40, alignment: .bottom)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(hourHandAngle))
                    .position(x: handCenterX + CGFloat(sin(hourHandAngle * .pi / 180) * Double(hourHandLength)), y: handCenterY - CGFloat(cos(hourHandAngle * .pi / 180) * Double(hourHandLength)))

                Rectangle()
                    .frame(width: 2, height: 60, alignment: .bottom)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(minuteHandAngle))
                    .position(x: handCenterX + CGFloat(sin(minuteHandAngle * .pi / 180) * Double(minuteHandLength)), y: handCenterY - CGFloat(cos(minuteHandAngle * .pi / 180) * Double(minuteHandLength)))
            }
        }
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { _ in
            updateClockHandsPositions()
        }
        .onAppear {
            updateClockHandsPositions()
        }
    }

    private func updateClockHandsPositions() {
        currentTime = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            hourHandAngle = Double(hour % 12) * 30 + Double(minute) / 60 * 30
            minuteHandAngle = Double(minute) * 6
        }
    }
}

struct CityListView: View {
    @Binding var currentTime: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 46) {
            CityRow(city: "Istanbul", country: "Turkey", time: currentTimeInCity(timezone: 3))
            CityRow(city: "New York", country: "USA", time: currentTimeInCity(timezone: -5))
            CityRow(city: "London", country: "United Kingdom", time: currentTimeInCity(timezone: 0))
        }
    }

    func currentTimeInCity(timezone: Int) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezone * 3600)
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: currentTime)
    }
}

struct CityRow: View {
    var city: String
    var country: String
    var time: String
    
    var body: some View {
        HStack {
            
            Text("\(city), \(country)")
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("\(time)")
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
