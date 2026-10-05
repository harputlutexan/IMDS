//
//  ProfilePageModel.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 17.11.2023.
//

import Foundation

class ProfilePageModel: ObservableObject {
    
    @Published var totalTest: Int = 0
    @Published var totalCorrectResult: Int = 0
    @Published var averageTime: Double = 0.0
    @Published var totalQuestionSolved: Int = 0
    @Published var totalSumOfTimes: String = "" // New property for the sum of times

    
    func updateValues() {
        let dataManager = DataManager()
        totalTest = dataManager.getMaxTestSolved()
        totalCorrectResult = dataManager.getCountAllTrueValues()
        let (sum, average) = dataManager.updateProfilePageAverageTime()
        averageTime = average
        let totalSumOfTimesSecond = sum
        totalSumOfTimes = String(format: "%.2f min.", totalSumOfTimesSecond/60)
        
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        totalQuestionSolved = dataManager.getAllAvailableAccuracy(csvManager: csvManager).count
      //  print("ProfilePageModel called \(totalCorrectResult)")
        
    }
    
    func getSolvedQuestions() -> Int {
        let currentExperience = PreferenceManager.shared.getExperience()
        return DataExperience().getSolvedQuestions(experienceLevel: currentExperience)
    }
    
    
    func analyzeProgressViaChatGPT(completion: @escaping (String?) -> Void) {
        let currentExperience = PreferenceManager.shared.getExperience()
        print("ProfilePageView \(currentExperience)")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        if let falsequestions = csvManager.readSelectedExperienceAndAccuracyData(forSelectedExperience: currentExperience) {
            print("getSolvedQuestions lines: \(falsequestions)")
            let chatGPT = ChatGPT()
            let chatGPTQuestion = DataContractIOS.chatGPTQuestion + falsequestions
            chatGPT.sendMessage(message: chatGPTQuestion) { response in
                if let responseString = response {
                    print(responseString)
                    completion(responseString) // Use completion handler to return the response string
                } else {
                    completion(nil) // If there is no response, call the completion handler with nil
                }
            }
        } else {
            completion(nil) // If reading from the CSV fails, call the completion handler with nil
        }
    }
    
    
}


