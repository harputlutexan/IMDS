//
//  UpdateTimeForLife.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 11.12.2023.
//

import Foundation
import SwiftUI


class UpdateTimeForLife: ObservableObject {
       // counter only works if life is less than max
    // to determine passing time comparing to 4 hours-new life duration
    // if less than 4 hours continue counter
    func updateLifeAndTime(additionalLives: Int) {
        let maxUserLife = DataContractIOS.maxUserLife // Adjust this value as needed now 3
        let currentLifeOfPlayer = PreferenceManager.shared.getUserLife()

        //let timeForNewLife = DataContractIOS.timeForNewLifeSeconds // Adjust this value as needed now 4 hours
       // let additionalLives = Int(timeDifferenceBetweenOldandNew / timeForNewLife)
        var newLife = currentLifeOfPlayer + additionalLives
        if newLife >= maxUserLife {
            newLife = maxUserLife
            PreferenceManager.shared.updateUserLife(userLife: newLife)
            //print("UpdateTimeForLife updateLifeAndTime \(currentLifeOfPlayer)")
            clearTimePreferences()
        }else{
            let preferenceManager = PreferenceManager.shared
            preferenceManager.updateUserLife(userLife: newLife)
            let timeDifferenceBetweenOldandNew = preferenceManager.getTimeDifference()
            let newTimeAfterClosing = timeDifferenceBetweenOldandNew - (Double(additionalLives) * DataContractIOS.timeForNewLifeSeconds)
            let startTime = preferenceManager.getstartTime()
            let updatedStartTime = startTime - newTimeAfterClosing
            preferenceManager.updateStartTime(startTime: updatedStartTime)
           // print("UpdateTimeForLife lifeOfPlayer \(PreferenceManager.shared.getUserLife())")
           // print("UpdateTimeForLife newTimeAfterClosing \(newTimeAfterClosing)")
        }
        
    }
    
    func clearTimePreferences() {
        PreferenceManager.shared.updateTimeDifference(timeDifferenceBetweenOldandNew: 0)
        //PreferenceManager.shared.updatePreviousCountDownTime(time: 0)
        PreferenceManager.shared.updateStartTime(startTime: DataContractIOS.timeForNewLifeSeconds)
       // print("UpdateTimeForLife cleared \(PreferenceManager.shared.getUserLife())")
    }
    

    
    // this is to check the time between opening app
    // makes current time as second
     func checkTimeBetweenAppCloseandOpen() {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyMMddHHmmss"
            let newTime = dateFormat.string(from: Date())
            if let currentDate = dateFormat.date(from: newTime) {
                let newTimeAsInt = Double(currentDate.timeIntervalSince1970)
                // oldTime is the one saved at the new time of last exit of app
                // but as default value for first installation of app at that time is recorded
       
                var oldTimeInitial = PreferenceManager.shared.getPreviousCountDownTime()
                print("ContentView newTimeAsInt \(newTimeAsInt) oldTimeInitial \(oldTimeInitial)")
                if oldTimeInitial == 0 {
                    oldTimeInitial = newTimeAsInt
                }
                PreferenceManager.shared.updatePreviousCountDownTime(time: newTimeAsInt)

                // check current life if max do nothnig just record time
                let currentPlayerLife = PreferenceManager.shared.getUserLife()
                if currentPlayerLife < DataContractIOS.maxUserLife{
                    // time difference between using app
                    let timeDifferenceBetweenOldandNew = newTimeAsInt - oldTimeInitial
                    PreferenceManager.shared.updateTimeDifference(timeDifferenceBetweenOldandNew: timeDifferenceBetweenOldandNew)
                   print("UpdateTimeForLife timeDifferenceBetweenOldandNew \(timeDifferenceBetweenOldandNew)")
                    let additionalLives = Int(timeDifferenceBetweenOldandNew / DataContractIOS.timeForNewLifeSeconds)
                    print("UpdateTimeForLife additionalLives \(additionalLives)")
                    if additionalLives >= 1 {
                        updateLifeAndTime(additionalLives: additionalLives)
                    } else{
                        let preferenceManager = PreferenceManager.shared
                        let startTime = preferenceManager.getstartTime()
                        print("UpdateTimeForLife startTime \(startTime)")
                        let updatedStartTime  = startTime - timeDifferenceBetweenOldandNew
                        print("UpdateTimeForLife updatedStartTime \(updatedStartTime)")
                        if updatedStartTime < 0 {
                            let oldLife = PreferenceManager.shared.getUserLife()
                            PreferenceManager.shared.updateUserLife(userLife: (oldLife + 1))
                        //    print("UpdateTimeForLife oldLife \(oldLife)")
                            PreferenceManager.shared.updateStartTime(startTime: DataContractIOS.timeForNewLifeSeconds)
                        }else{
                            PreferenceManager.shared.updateStartTime(startTime: updatedStartTime)
                        }
                    }
                    // save the new opening time which will be the old when use app again
                    // the usage during app adds in home as time with timeBetweenActivitiesPreference
                }

                
                // Save the values to UserDefaults
            }
        
    }
}

// Other functions if needed

