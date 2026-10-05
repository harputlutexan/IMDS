import Combine
import Foundation
import SwiftUI

// this class is used to manage CSV file and retrieve or update data
class DataManager: ObservableObject {
    
    //@Published property observers in your DataManager to trigger updates when the data changes.
    var statisticsData: [(question: String, userAnswer: String, correctAnswer: String, chatCPTExplanation: String)] = []
    var allStatisticsData: [(testIdName: String, date: String, experience: String, accuracyCount: Int)] = []
    var profilePageData: [(testIdName: String, accuracyCount: Int)] = []

    var hasFetchedallStatisticsData = false

    
    // Function to update statisticsData
    func updateTestDeails(testId: Int) ->  [(question: String, userAnswer: String, correctAnswer: String, chatCPTExplanation: String)] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)        // Assuming there is a function to fetch the data for the specified testId
        if let question = csvManager.readConcatenatedData(forID: testId, atIndex: DataContractIOS.CSVquestionColumn),
           let userAnswer = csvManager.readConcatenatedData(forID: testId, atIndex: DataContractIOS.CSVselectedOptionColumn),
           let correctAnswer = csvManager.readConcatenatedData(forID: testId, atIndex: DataContractIOS.CSVcorrectAnswerOptionColumn),
           let chatCPTExplanation = csvManager.readConcatenatedData(forID: testId, atIndex: DataContractIOS.CSVTestDetailExplanationColum),
           !question.isEmpty, !userAnswer.isEmpty, !correctAnswer.isEmpty, !chatCPTExplanation.isEmpty {
            statisticsData = [(question: question, userAnswer: userAnswer, correctAnswer: correctAnswer, chatCPTExplanation: chatCPTExplanation)]
            //print("updateTestDeails: \(statisticsData)")
        } else {
            // Handle the case where any of the values is empty or fetching fails
            print("updateTestDeails Failed to fetch data for testID: \(testId)")
        }
        return statisticsData
    }
    
    // refresh at mainview
    func updateAllStatisticsData()-> [(testIdName: String, date: String, experience: String, accuracyCount: Int)] {
        guard !hasFetchedallStatisticsData else { return []}
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath) 
        // get all available test IDs
        let allAvailableTestIDs = getAllAvailableTestIDs(csvManager: csvManager)
        //print("allAvailableTestIDs: \(allAvailableTestIDs)")
        var allStatisticsData: [(testIdName: String, date: String, experience: String, accuracyCount: Int)] = []
        // Iterate through each unique test ID
        for overallTestId in allAvailableTestIDs {
            //print("Processing testID: \(overallTestId)")
            // Fetch necessary data for each test ID
            guard let accuracyValues = csvManager.readConcatenatedData(forID: overallTestId, atIndex: DataContractIOS.CSVaccuracyColumn),
                  var date = csvManager.readConcatenatedData(forID: overallTestId, atIndex: DataContractIOS.CSVdateColumn),
                  var experience = csvManager.readConcatenatedData(forID: overallTestId, atIndex: DataContractIOS.CSVExperienceColumn),
                  !experience.isEmpty, !accuracyValues.isEmpty, !date.isEmpty else {
                print("Failed to fetch data for testID: \(overallTestId)")
                continue
            }
            date = date.components(separatedBy: "\n").first!
            //print("date: \(date)")
            experience = experience.components(separatedBy: "\n").first!
            let accuracyCount = countTrueValues(accuracyValues: accuracyValues)
            allStatisticsData.append((testIdName: String(overallTestId), date: date, experience: experience, accuracyCount: accuracyCount))
            // print("allStatisticsData: \(allStatisticsData)")
        }
        self.allStatisticsData = allStatisticsData
        hasFetchedallStatisticsData = true
        // print("allStatisticsData: \(allStatisticsData)")
        return allStatisticsData
    }
    

    
    func getAllAvailableAccuracy(csvManager: CSVManager) -> [String] {
        var allTestAccuracy: [String] = []
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
       // let csvManager = CSVManager(filePath: filePath)
        
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            //print("rows: \(rows)")

            for row in rows {
                let columns = row.components(separatedBy: ";")
                if columns.count > DataContractIOS.CSVaccuracyColumn  {
                    let allAccuracy = columns[DataContractIOS.CSVaccuracyColumn]
                    allTestAccuracy.append(allAccuracy)
                }
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
        // print("DataManager allTestAccuracy: \(allTestAccuracy)")

        return allTestAccuracy
    }
    
    
    
    
    
    func getAllTimes(csvManager: CSVManager) -> [Int] {
        var allTestTime: [Int] = []
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
       // let csvManager = CSVManager(filePath: filePath)
        
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            //print("rows: \(rows)")

            for row in rows {
                let columns = row.components(separatedBy: ";")
                if columns.count > DataContractIOS.CSVtimeColumn,  let allTimes = Int(columns[DataContractIOS.CSVtimeColumn])  {
                    allTestTime.append(allTimes)
                }
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
        // print("DataManager allTestAccuracy: \(allTestAccuracy)")

        return allTestTime
    }
    
    
    
    func getAllAvailableTestIDs(csvManager: CSVManager) -> [Int] {
        var allTestIDs: [Int] = []
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        //let csvManager = CSVManager(filePath: filePath)
        
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            //print("rows: \(rows)")

            for row in rows {
                let columns = row.components(separatedBy: ";")
                if columns.count > DataContractIOS.CSVtestIdColumn, let overallTestId = Int(columns[DataContractIOS.CSVtestIdColumn]) {
                    allTestIDs.append(overallTestId)
                }
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
        let uniqueTestIDs = Array(Set(allTestIDs))
        let sortedTestIDs = uniqueTestIDs.sorted()

  //     print("DataManager uniqueTestIDs: \(sortedTestIDs)")

        return sortedTestIDs
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
    
    func getMaxTestSolved()-> (Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        // get all available test IDs
        let allAvailableTestIDs = getAllAvailableTestIDs(csvManager: csvManager)
        var maxTestSolved : Int = 0
            if let maxTestID = allAvailableTestIDs.max() {
                maxTestSolved = maxTestID
            } else {
                // Handle the case where allAvailableTestIDs is empty
                maxTestSolved = 0
            }
        return maxTestSolved
    }
    
    // called at ProfilePageModel to get total accuracy
    func getCountAllTrueValues()-> (Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        // get all available test IDs
        let allAvailableAccuracy = getAllAvailableAccuracy (csvManager: csvManager)
        // print("allAvailableAccuracy: \(allAvailableAccuracy)")
        let trueValues = allAvailableAccuracy.filter { $0.lowercased() == "true" }.count
        return trueValues
    }
    
    
    
    func updateProfilePageAverageTime()-> (sum: Double, average: Double)  {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        // get all available test IDs
        let allAvailableTimes = getAllTimes (csvManager: csvManager)
        var averageTime: Double = 0
        var sumOfTimes: Double = 0

        do {
            let csvString = try String(contentsOfFile: csvFilePath, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            let rowCount = rows.count
            // Print the row count or use it as needed
          //  print("Row Count: \(rowCount)")
           // print("All test count: \(String(describing: rowCount))")
            sumOfTimes = Double(allAvailableTimes.reduce(0, +))
           // print("Sum of all elements: \(sumOfTimes)")
            // print("allAvailableAccuracy: \(allAvailableAccuracy)")
            averageTime = (Double(sumOfTimes) / Double(rowCount)).rounded(toPlaces: 1)
            
        } catch {
            print("Error reading CSV file: \(error)")
        }
        

        return (sumOfTimes, averageTime)
    }
    
}
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
