
import Foundation
import SwiftUI


// this class has only timer operations
class HomeViewModel: ObservableObject {
   // @Published var dataLoaded = false
    @Published var elapsedTime = ""
    var lifeTimer: Timer?
    
    var timerInitialized = false

    func initCountdownTimer() {
        
//        guard !timerInitialized else {
//               // Timer already initialized, no need to set it up again
//               return
//           }
        let currentLife = PreferenceManager.shared.getUserLife()
        print("HomeViewModel lifeOfPlayer1 \(currentLife)")
        
        // if max life show timeForNewLifeSeconds, or run counter
        if currentLife<DataContractIOS.maxUserLife{
            lifeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerInitialized = true // Set the flag to true indicating timer setup

        }else{
            // = DataContractIOS.timeForNewLifeSeconds
            let startTime = DataContractIOS.timeForNewLifeSeconds
            let hours = Int(startTime) / 3600
            let minutes = (Int(startTime) % 3600) / 60
            let seconds = Int(startTime) % 60
            elapsedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            //print("elapsedTime1 \(elapsedTime)")
          //  print("HomeViewModel initCountdownTimer \(startTime)")
        }
     }
    
    // each second counter being updated here as elapsed time
    @objc func updateTimer() {
        guard let timer = lifeTimer, timer.isValid else {
              // Timer is not valid, stop further execution
              return
          }

        // this is for counting back
        // print("HomeViewModel updateTimer \(startTime)")
        let preferenceManager = PreferenceManager.shared
        var counterForEachUsage = preferenceManager.getCounterForEachUsage()
        // print("updateTimer counterForEachUsage \(counterForEachUsage)")

        let startTime = preferenceManager.getstartTime()
        // print("updateTimer startTime \(startTime)")
        // counterTime is time removing time after counting back
        let counterTime = startTime - counterForEachUsage
        //  this is for record timeBetweenActivities
        counterForEachUsage += 1
        preferenceManager.updateCounterForEachUsage(counterForEachUsage: counterForEachUsage)
        // print("updateTimer counterTime \(counterTime)")
         //let sn = Int(timeDifference - startTime)
        if counterTime > 0 {
            let hours = Int(counterTime) / 3600
            let minutes = (Int(counterTime) % 3600) / 60
            let seconds = Int(counterTime) % 60
            elapsedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            // Update your UI here, e.g., label.text = elapsedTime
            //print("elapsedTime \(elapsedTime)")
            // Save elapsed time in pref
        } else {
            onFinish()
        }
     }
    
    func onFinish() {
        print("HomeViewModel onFinish")
        let maxUserLife = DataContractIOS.maxUserLife
        // Timer finished, implement onFinish logic here
       // print("HomeViewModel onFinish \(currentLife)")
        let preferenceManager = PreferenceManager.shared
        let currentLife = preferenceManager.getUserLife()
        var newLife = currentLife+1
        // check the added life if less than max or not
        if newLife == maxUserLife{
            print("onFinish newLife2 \(newLife)")
            newLife = maxUserLife
            preferenceManager.updateUserLife(userLife: (newLife))
            stopTimer()
            preferenceManager.updateStartTime(startTime: DataContractIOS.timeForNewLifeSeconds)
            // time difference between opening two apps
            preferenceManager.updateTimeDifference(timeDifferenceBetweenOldandNew: 0)
            //preferenceManager.updatePreviousCountDownTime(time: 0)
            preferenceManager.updateCounterForEachUsage(counterForEachUsage: 0)
            // to refresh view need to update elapsedTime
            let startTime = DataContractIOS.timeForNewLifeSeconds
            let hours = Int(startTime) / 3600
            let minutes = (Int(startTime) % 3600) / 60
            let seconds = Int(startTime) % 60
            elapsedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }else{
            print("onFinish newLife \(newLife)")
            preferenceManager.updateUserLife(userLife: (newLife))
            preferenceManager.updateStartTime(startTime: DataContractIOS.timeForNewLifeSeconds)
            // time difference between opening two apps
            preferenceManager.updateTimeDifference(timeDifferenceBetweenOldandNew: 0)
            //preferenceManager.updatePreviousCountDownTime(time: 0)
            preferenceManager.updateCounterForEachUsage(counterForEachUsage: 0)
            initCountdownTimer()
        }

    }
    
    func stopTimer() {
        DispatchQueue.main.async {
            self.lifeTimer?.invalidate()
            self.lifeTimer = nil
        }
    }
    
    
        
}


