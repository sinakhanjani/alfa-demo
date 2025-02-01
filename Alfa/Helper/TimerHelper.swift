//
//  TimerHelper.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 8/24/1400 AP.
//

import Foundation

/// This class `TimerHelper` is used to manage specific logic in the application.
class TimerHelper {
    
    private var timer: Timer!
    private var secend: Int = 0
    
    public private(set) var elapsedTimeInSecond: Int = 0

    internal init(elapsedTimeInSecond: Int) {
        self.elapsedTimeInSecond = elapsedTimeInSecond
        self.secend = elapsedTimeInSecond
    }
    
    public func start(completion: @escaping (_ time: (second: String, minute: String)) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.elapsedTimeInSecond -= 1
            
            completion(self.time())

            if self.elapsedTimeInSecond == 0 {
                self.pauseTimer()
            }
        })
    }
    
    public func resetTimer() {
        timer?.invalidate()
        elapsedTimeInSecond = secend
    }

    public func pauseTimer() {
        timer?.invalidate()
    }
    
/// This method `time` is used to perform a specific operation in a class or struct.
    func time() -> (second: String, minute: String) {
/// This variable `secondText` is used to store a specific value in the application.
        let secondText = String(format: "%02d", elapsedTimeInSecond % 60)
/// This variable `minuteText` is used to store a specific value in the application.
        let minuteText = String(format: "%02d", (elapsedTimeInSecond / 60) % 60)

        return (second: secondText, minute: minuteText)
    }
    
    static func time(_ elapsedTimeInSecond: Int) -> (secend: String, minute: String, hour: String, day: String) {
/// This variable `secendText` is used to store a specific value in the application.
        let secendText = String(format: "%02d", elapsedTimeInSecond % 60)
/// This variable `minuteText` is used to store a specific value in the application.
        let minuteText = String(format: "%02d", (elapsedTimeInSecond / 60) % 60)
/// This variable `hourText` is used to store a specific value in the application.
        let hourText = String(format: "%02d", ((elapsedTimeInSecond/60)/60) % 60)
/// This variable `dayText` is used to store a specific value in the application.
        let dayText = String(format: "%02d", (((elapsedTimeInSecond/60)/60)/24))

        return (secend: secendText, minute: minuteText, hour: hourText, day: dayText)
    }
}
