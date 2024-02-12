//
//  CronometerView.swift
//  ClockApp
//
//  Created by Hilal on 21.12.2023.
//

import Foundation
import SwiftUI

struct CronometerView: View {
    @State private var timerElapsed: TimeInterval = 0
    @State private var isRunning = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                Text("CRONOMETER")
                    .font(.system(size: 25, weight: .regular, design: .default))

                Spacer().frame(height: 90)
                
                Text("\(timeString(time: timerElapsed))")
                    .font(.system(size: 70))
                    .fontWeight(.light)
                    .padding()
                    .foregroundColor(.black)
                
                Spacer().frame(height: 90)
                
                HStack {
                    Button(action: resetCronometer) {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 100, height: 100)
                                .background(RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.orange, lineWidth: 2)
                                    .background(Color.white))
                                .cornerRadius(100)
                                
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 90, height: 90)
                                .background(RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.black, lineWidth: 2)
                                    .background(Color.white))
                                .cornerRadius(100)
                
                            Text("Reset")
                                .font(Font.custom("Inter", size: 22))
                                .foregroundColor(.black)
                        }
                    }
                    .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
                    
                    Spacer().frame(width:60)

                    if isRunning {
                        Button(action: stopCronometer) {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 100, height: 100)
                                    .background(RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.orange, lineWidth: 2) 
                                        .background(Color.white))
                                    .cornerRadius(100)
                                    
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 90, height: 90)
                                    .background(RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.black, lineWidth: 2)
                                        .background(Color.orange.opacity(0.4)))
                                    .cornerRadius(100)
                                
                                Text("Stop")
                                    .font(Font.custom("Inter", size: 22))
                                    .foregroundColor(.black)
                            }
                        }
                        .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
                        
                        
                    }else{
                        Button(action: startCronometer) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 100, height: 100)
                                    .background(RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.orange, lineWidth: 2)
                                        .background(Color.white))
                                    .cornerRadius(100)
                                    
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 90, height: 90)
                                    .background(RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.black, lineWidth: 2)
                                        .background(Color.white))
                                    .cornerRadius(100)
                                
                                Text("Start")
                                    .font(Font.custom("Inter", size: 22))
                                    .foregroundColor(.black)
                            }
                        }
                        .shadow(color: Color.orange.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                
            }
            .onReceive(timer) { _ in
                if self.isRunning {
                    self.timerElapsed += 0.01
                }
            }
        }
    }
    func createButton(title: String, position: CGPoint) -> UIButton {
        let button = UIButton(type:.system)
        button.setTitle(title, for:.normal)
        
        // Customize your button's appearance here
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for:.normal)
        
        // Set size and position
        button.frame.size = CGSize(width :100 , height :100 )
        button.center = position
        
        return button
    }
    
    private func startCronometer() {
        isRunning = true
    }
    private func stopCronometer() {
        isRunning = false
    }
    private func resetCronometer() {
        isRunning = false
        timerElapsed = 0
    }
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let miliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, miliseconds)
    }
}

struct CountdownView: View {
    @ObservedObject var viewModel: CronometerViewModel
    @State private var animationAmount: Double = 2.0
    
    var body: some View {
        VStack {
            Text("\(Int(viewModel.remainingTime / 1000))")
                .font(.largeTitle)
                .scaleEffect(animationAmount)
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onReceive(viewModel.$remainingTime) { time in
            withAnimation(.easeInOut(duration: 0.5)) {
                animationAmount = 2.5
            }
        }
    }
}

#Preview {
    ContentView()
}
