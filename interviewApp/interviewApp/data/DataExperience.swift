//
//  DataExperience.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 5.01.2024.
//

import Foundation
import SwiftUI


class DataExperience{
    
    var endRow : Int = 0
    
    
    
    func getCvsQuestionSets(experience : String) -> ([[String]]){
        // depending on experience level filename will be defined
        var fileName : String = ""
        var questionSet : [[String]] = []
        switch experience {
        case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
            fileName = "FinalQuestionDatabaseBeginner"
        case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
            fileName = "FinalQuestionDatabaseInt"
        case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
            fileName = "FinalQuestionDatabaseUppInt"
        case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
            fileName = "FinalQuestionDatabaseAdv"
        case DataContractIOS.EXPERIENCE_EXPERT_STRING:
            fileName = "FinalQuestionDatabaseExpert"
        case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1:
            fileName = "Assessment1"
        case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2:
            fileName = "Assessment2"
        case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3:
            fileName = "Assessment3"
        default:
            // Default case, handle if none of the specific conditions match
            
            break
        }
        // print("DataExperience fileName \(fileName)")
        // Use filePath to access the CSV file
        // 5 questions and their 1 correct answer and 4 options will be recorded
        questionSet = readQuestionOptionSets(fileName: fileName)
        // print("DataExperience readAllQuestionOptionSets \(questionSet)")
        // print("File path:", filePath)
        
        return questionSet
    }
    
    
    func readQuestionOptionSets(fileName: String) -> [[String]] {
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
                let lines = csvString.components(separatedBy: "\n")
                var allQuestionOptionSets: [[String]] = []
                let difficultyManager = PreferenceManager.shared
                let experienceLevel = difficultyManager.getExperience()
                var startRow = difficultyManager.getCurrentTestID(for: experienceLevel)
                //print("DataExperience lines \(lines)")

               // print("DataExperience startRow1 \(startRow)")
                
                
                // normal testlerde (testId-1)x5+1
                switch experienceLevel {
                    // each test
                case DataContractIOS.EXPERIENCE_BEGINNER_STRING,
                    DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING,
                    DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING,
                    DataContractIOS.EXPERIENCE_ADVANCED_STRING,
                    DataContractIOS.EXPERIENCE_EXPERT_STRING:
                    startRow = (startRow-1)*5+1
                    
                case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1,
                    DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2,
                    DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3:
                    startRow = 1
                    
                default:
                    // Handle default case
                    break
                }
                
                print("DataExperience startRow2 \(startRow)")
                
                switch experienceLevel {
                case DataContractIOS.EXPERIENCE_BEGINNER_STRING,
                    DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING,
                    DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING,
                    DataContractIOS.EXPERIENCE_ADVANCED_STRING,
                    DataContractIOS.EXPERIENCE_EXPERT_STRING:
                    endRow = startRow + DataContractIOS.regularTestsQuestionNumbers - 1
                    
                case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1,
                    DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2,
                    DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3:
                    endRow = startRow + DataContractIOS.assessmentQuestionNumbers - 1
                    
                default:
                    // Handle default case
                    break
                }
                //  print("DataExperience endRow \(endRow)")
                
                guard endRow < lines.count else {
                    print("Invalid endRow value.")
                    return []
                }

                for rowIndex in startRow...endRow {
                    let line = lines[rowIndex]
                    let values = line.components(separatedBy: ";")
                   // print("values \(values)")
                    allQuestionOptionSets.append(values)
                }
                return allQuestionOptionSets
            } catch {
                print("Error reading data from CSV file: \(error)")
                return []
            }
        }else {
            // Handle the case where the file is not found
            print("CSV file not found.")
            return []
        }
    }
    
    func getAllCsvQuestionNumber(experience : String)-> Int{
        // depending on experience level filename will be defined
        //  print("DataExperience getCsvQuestionNumber \(experience)")
        var lineCount : Int = 0
        var fileName : String = ""
        switch experience {
            // 1- Assessment 1 is finished, depending on success beginner or intermediate will be opned
        case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
            fileName = "FinalQuestionDatabaseBeginner"
        case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
            fileName = "FinalQuestionDatabaseInt"
        case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
            fileName = "FinalQuestionDatabaseUppInt"
        case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
            fileName = "FinalQuestionDatabaseAdv"
        case DataContractIOS.EXPERIENCE_EXPERT_STRING:
            fileName = "FinalQuestionDatabaseExpert"
        default:
            // Default case, handle if none of the specific conditions match
            break
        }
        //  print("DataExperience fileName \(fileName)")
        // Use filePath to access the CSV file
        lineCount = getAllQuestions(fileName: fileName)
        //  print("DataExperience filePath \(filePath)")
        // print("DataExperience lineCount \(lineCount)")
        return lineCount
    }
    
    func getAllQuestions(fileName: String)-> Int{
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
                let lines = csvString.components(separatedBy: "\n")
                let lineCount = lines.count
                return lineCount
            } catch {
                print("Error reading data from CSV file: \(error)")
                return 0
            }
        } else {
            // Handle the case where the file is not found
            print("CSV file not found.")
            return 0
        }
    }
    
    func updateTestLevel(){
        // Create a date formatter
        let dateFormatter = DateFormatter()

        // Set the date format
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"


        // Get the current date as Date
        let now = Date()

        // Convert the current date to a String
        let dateString = dateFormatter.string(from: now)
        
        
        let preferenceManager = PreferenceManager.shared
        let experienceLevel = preferenceManager.getExperience()
        //   print("DataExperience updateTestLevel \(experienceLevel)")
        
        
        // if all tests finished make selection with buttons and just check all question numbers
        if !preferenceManager.getAllTestsFinished() {
            switch experienceLevel {
                // 1- Assessment 1 is finished, depending on success beginner or intermediate will be opened
            case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1:
                if Double(getExperienceAccuracy(experienceLevel: experienceLevel)) > Double(DataContractIOS.assessmentQuestionNumbers) * DataContractIOS.assessmentTreshold {
                    preferenceManager.updateExperience(experienceLevel: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                }else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                }
                // 2- first assessment is done but score is not good to take intermediate and will solve beginner level questions
                // and each time check accuracy ratio or solved questions to pass next level
            case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
                let solvedQuestions = getSolvedQuestions(experienceLevel: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                let correctAnswers = getExperienceAccuracy(experienceLevel: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                let correctRatio = Double(correctAnswers) / Double(solvedQuestions)
                print("DataExperience correctRatio \(correctRatio)")
                // first achievement
                if solvedQuestions == 5 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementBeginner1)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner1)
                }
                // second achievement
                if correctAnswers >= 20 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementBeginner2)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner2)
                }
                // third achievement
                if correctRatio >= 0.7 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementBeginner3)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner3)
                }
                
                
                // there is titile line at the top so minus one
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_BEGINNER_STRING)-1
                print("DataExperience solvedQuestions \(solvedQuestions)")
                print("DataExperience allQuestions \(allQuestions)")
                if solvedQuestions > DataContractIOS.tresholdSolvedQuestion && (correctRatio > DataContractIOS.levelsTreshold || solvedQuestions >= allQuestions) {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                    if solvedQuestions >= allQuestions {
                       preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                   }
                    
                }  else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                }
                // 3- either has over 50% sccuess at assessment1 or 80% success at beginner or beginner tests finished
                // each time check accuracy ratio or solved questions to solve second assesment
            case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
                let solvedQuestions = getSolvedQuestions(experienceLevel: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                let correctAnswers = getExperienceAccuracy(experienceLevel: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                let correctRatio = Double(correctAnswers) / Double(solvedQuestions)
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)-1
                print("EXPERIENCE_INTERMEDIATE_STRING DataExperience correctAnswers \(correctAnswers)")
                //  print("DataExperience correctRatio \(correctRatio)")
                //  print("DataExperience solvedQuestions \(solvedQuestions)")
                //  print("DataExperience allQuestions \(allQuestions)")
                //first achievement
                if solvedQuestions == 5 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementIntermediate1)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate1)
                }
                // second achievement
                if correctAnswers >= 20 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementIntermediate2)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate2)
                }
                // third achievement
                if correctRatio >= 0.7 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementIntermediate3)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate3)
                }
                if solvedQuestions > DataContractIOS.tresholdSolvedQuestion && (correctRatio > DataContractIOS.levelsTreshold || solvedQuestions >= allQuestions) {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                    if solvedQuestions >= allQuestions {
                       preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                   }
                }else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                }
                //4- Assessment 2 is finished, depending on success beginner or intermediate will be opned
            case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2:
                if Double(getExperienceAccuracy(experienceLevel: experienceLevel)) > Double(DataContractIOS.assessmentQuestionNumbers) * DataContractIOS.assessmentTreshold {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_ADVANCED_STRING)

                }else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                }
                // 5- second assessment is done but score is not good to take advanced and will solve upper intermediate level questions
                // and each time check accuracy ratio or solved questions to pass next level
            case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
                let solvedQuestions = getSolvedQuestions(experienceLevel: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                let correctAnswers = getExperienceAccuracy(experienceLevel: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                let correctRatio = Double(correctAnswers) / Double(solvedQuestions)
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)-1
                
                if solvedQuestions == 5 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate1)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate1)
                }
                // second achievement
                if correctAnswers >= 20 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate2)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate2)
                }
                // third achievement
                if correctRatio >= 0.7 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate3)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate3)
                }
                
                
                if solvedQuestions > DataContractIOS.tresholdSolvedQuestion && (correctRatio > DataContractIOS.levelsTreshold || solvedQuestions >= allQuestions) {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                    if solvedQuestions >= allQuestions {
                       preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                   }
                }else {
                    preferenceManager.updateExperience(experienceLevel: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                }
                // 6- either has over 50% sccuess at assessment2 or 80% success at upper intermediate or tests finished
                // each time check accuracy ratio or solved questions to solve third assesment
            case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
                let solvedQuestions = getSolvedQuestions(experienceLevel: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                let correctAnswers = getExperienceAccuracy(experienceLevel: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                let correctRatio = Double(correctAnswers) / Double(solvedQuestions)
                
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_ADVANCED_STRING)-1
                if solvedQuestions == 5 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementAdvanced1)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced1)
                }
                // second achievement
                if correctAnswers >= 20 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementAdvanced2)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced2)
                }
                // third achievement
                if correctRatio >= 0.7 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementAdvanced3)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced3)
                }
                if solvedQuestions > DataContractIOS.tresholdSolvedQuestion && (correctRatio > DataContractIOS.levelsTreshold || solvedQuestions >= allQuestions) {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3)
                    preferenceManager.updateHighestLevelAchieved(newLevel: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                    if solvedQuestions >= allQuestions {
                       preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                   }
                }else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                }
                //7- Assessment 3 is finished, regardless of  success expert  will be opened
            case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3:
                preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_EXPERT_STRING)
                // 8- either has 80% success or tests finished all tests will be opened
            case DataContractIOS.EXPERIENCE_EXPERT_STRING:
                let solvedQuestions = getSolvedQuestions(experienceLevel: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                let correctAnswers = getExperienceAccuracy(experienceLevel: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                let correctRatio = Double(correctAnswers) / Double(solvedQuestions)
                if solvedQuestions == 5 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementExpert1)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert1)
                }
                // second achievement
                if correctAnswers >= 20 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementExpert2)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert2)
                }
                // third achievement
                if correctRatio >= 0.7 {
                    preferenceManager.setAchievementDate(currentDate: dateString, achievementKey: DataContractIOS.keyForDateAchievementExpert3)
                    preferenceManager.setAchievementCompletion(completed: true, achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert3)
                }
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_EXPERT_STRING)-1
                if solvedQuestions > DataContractIOS.tresholdSolvedQuestion && (correctRatio > DataContractIOS.levelsTreshold || solvedQuestions >= allQuestions) {
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                    preferenceManager.updateAllTestsFinished(allTestsFinished: true)
                }else {
                    preferenceManager.updateExperience(experienceLevel:DataContractIOS.EXPERIENCE_EXPERT_STRING)
                }
                // Add more cases as needed
            default:
                // Default case, handle if none of the specific conditions match
                break
            }
        }else{
            switch experienceLevel {
            case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
                // there is titile line at the top so minus one, check if all beginners finished
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_BEGINNER_STRING)-1
                let currentTestId = preferenceManager.getCurrentTestID(for: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                print("DataExperience allQuestions \(allQuestions) currentTestId \(currentTestId)")
                print("experienceLevel \(experienceLevel)")

                if currentTestId >= allQuestions/DataContractIOS.regularTestsQuestionNumbers{
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_BEGINNER_STRING)
                }
            case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
                // there is titile line at the top so minus one, check if all beginners finished
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)-1
                let currentTestId = preferenceManager.getCurrentTestID(for: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                print("DataExperience allQuestions \(allQuestions) currentTestId \(currentTestId)")
                print("experienceLevel \(experienceLevel)")

                if currentTestId >= allQuestions/DataContractIOS.regularTestsQuestionNumbers{
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING)
                }
            case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
                // there is titile line at the top so minus one, check if all beginners finished
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)-1
                let currentTestId = preferenceManager.getCurrentTestID(for: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                print("DataExperience allQuestions \(allQuestions) currentTestId \(currentTestId)")
                if currentTestId >= allQuestions/DataContractIOS.regularTestsQuestionNumbers{
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING)
                }
            case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
                // there is titile line at the top so minus one, check if all beginners finished
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_ADVANCED_STRING)-1
                let currentTestId = preferenceManager.getCurrentTestID(for: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                print("DataExperience allQuestions \(allQuestions) currentTestId \(currentTestId)")
                if currentTestId >= allQuestions/DataContractIOS.regularTestsQuestionNumbers{
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_ADVANCED_STRING)
                }
            case DataContractIOS.EXPERIENCE_EXPERT_STRING:
                // there is titile line at the top so minus one, check if all beginners finished
                let allQuestions = getAllCsvQuestionNumber(experience: DataContractIOS.EXPERIENCE_EXPERT_STRING)-1
                let currentTestId = preferenceManager.getCurrentTestID(for: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                print("DataExperience allQuestions \(allQuestions) currentTestId \(currentTestId)")
                if currentTestId >= allQuestions/DataContractIOS.regularTestsQuestionNumbers{
                    preferenceManager.clearTestID(for: DataContractIOS.EXPERIENCE_EXPERT_STRING)
                }
            default:
                break
            }
        }
        let achievementModel = AchievementModel() // This calls init
        achievementModel.loadData()
        
        
    }
    
    // correctValues according to selected expereinece level
    func getExperienceAccuracy(experienceLevel: String) -> Int {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        let allAccuracyForCurrentExperience = csvManager.readSelectedExperienceData(forSelectedExperience: experienceLevel, atIndex: DataContractIOS.CSVaccuracyColumn)
        let accuracyCount = countTrueValues(accuracyValues: allAccuracyForCurrentExperience!)
        //  print("DataExperience getExperienceAccuracy accuracyCount\(accuracyCount)")
        return accuracyCount
    }
    
    func getSolvedQuestions(experienceLevel: String) -> Int{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        var lineCount = 0
        if let solvedTest = csvManager.readSelectedExperienceData(forSelectedExperience: experienceLevel, atIndex: DataContractIOS.CSVquestionColumn) {
            //print("DataExperience solvedTest \(String(describing: solvedTest))")
            let lines = solvedTest.components(separatedBy: "\n").filter { !$0.isEmpty }
            //print("getSolvedQuestions lines: \(lines)")

            lineCount = lines.count
            //print("getSolvedQuestions Line count: \(lineCount)")
        }
        //let solvedQuestionSet = solvedTest!.count
        return lineCount
    }
    
    
    
    func countTrueValues(accuracyValues: String) -> Int {
        var trueCount = 0 // Initialize the count of "true" values
        
        do {
            // Your existing code to read the CSV file and extract values...
            
            // After getting the result values
            for resultValue in accuracyValues.components(separatedBy: "\n") {
                // Assuming the result values are boolean strings ("true" or "false")
                if resultValue.lowercased() == "true" {
                    trueCount += 1
                }
            }
        }
        
        return trueCount
    }
    
}

