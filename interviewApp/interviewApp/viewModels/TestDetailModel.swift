//
//  StatisticsPageTestDetailModel.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 14.11.2023.
import Foundation
import SwiftUI


class TestDetailModel: ObservableObject {
    
    //var statisticsData: [(question: String, userAnswer: String, correctAnswer: String)] = []
    @AppStorage(DataContractIOS.testDetaiIdPreference) private var testDetailId: Int = 0


    func updateTestDetails() -> [(question: String, userAnswer: String, correctAnswer: String, chatCPTExplanation: String)] {
        let dataManager = DataManager()
        let rawStatisticsData = dataManager.updateTestDeails(testId: testDetailId)

        // Split the long strings into separate tuples
        let separatedStatisticsData = rawStatisticsData.flatMap { tuple -> [(String, String, String, String)] in
            let questions = tuple.question.components(separatedBy: "\n")
            let userAnswers = tuple.userAnswer.components(separatedBy: "\n")
            let correctAnswers = tuple.correctAnswer.components(separatedBy: "\n")
            let detailedExplanations = tuple.chatCPTExplanation.components(separatedBy: "\n")

            // Check for the minimum count among all components to avoid index out of range errors
            let itemCount = min(questions.count, userAnswers.count, correctAnswers.count, detailedExplanations.count) - 1 // Adjusting for dropLast()

            return (0..<itemCount).map { index in
                (questions[index], userAnswers[index], correctAnswers[index], detailedExplanations[index])
            }
        }

        return separatedStatisticsData
    }
    
    
}
