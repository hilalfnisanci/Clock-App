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
    @State private var hourHand = ClockHand(id: 0, angle: 0)
    @State private var minuteHand = ClockHand(id: 1, angle: 0)
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
                    .offset(x: -2.5, y: -80)

                drawClockHand(hand: hourHand, length: 40, xOffset: 7.5, yOffset: -80, geometry: geometry)
                drawClockHand(hand: minuteHand, length: 60, xOffset: 5, yOffset: -100, geometry: geometry)
                
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
                updateClockHandsPositions()
            }
        }
    }

    private func updateClockHandsPositions() {
        let hour = Calendar.current.component(.hour, from: currentTime)
        hourHand.angle = Double(hour % 12) * 30 - 90

        let minute = Calendar.current.component(.minute, from: currentTime)
        hourHand.angle += Double(minute) / 60 * 30

        minuteHand.angle = Double(minute) * 6 - 90
    }

    private func drawClockHand(hand: ClockHand, length: CGFloat, xOffset: CGFloat, yOffset: CGFloat, geometry: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 2, height: length, alignment: .bottom)
            .foregroundColor(.white)
            .rotationEffect(.degrees(hand.angle - 90))
            .position(x: geometry.size.width / 2+xOffset, y: geometry.size.height / 2+yOffset)
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

struct ClockHand: Identifiable {
    var id: Int
    var angle: Double
}

#Preview {
    ContentView()
}
