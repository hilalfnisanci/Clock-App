//
//  CronometerViewModel.swift
//  ClockApp
//
//  Created by Hilal on 21.12.2023.
//

import Foundation
import SwiftUI
import Combine

class CronometerViewModel: ObservableObject {
    @Published var remainingTime: TimeInterval = 60
    var timer: Timer?
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {return}
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            }else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
}
