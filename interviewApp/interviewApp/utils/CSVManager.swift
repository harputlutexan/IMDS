import Foundation
import SwiftUI


class CSVManager {
    let filePath: String

    // when get an instance at different class filePath is assigned at that class
    init(filePath: String) {
        self.filePath = filePath
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: filePath) {
            // If the file doesn't exist, create a new file with an empty string as content
            fileManager.createFile(atPath: filePath, contents: Data(), attributes: nil)
            print("New file created at: \(filePath)")
        }
    }
    
    func appendTestData(_ data: [Any]) {
        let rowString = data.map { String(describing: $0) }.joined(separator: ";")
        let csvString = rowString + "\n"
        
        if let fileHandle = FileHandle(forWritingAtPath: filePath) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(csvString.data(using: .utf8)!)
            fileHandle.closeFile()
            //print("New test data appended to CSV file.")
           // print("CSV file at: \(filePath)")
            
        } else {
            do {
                try csvString.write(toFile: filePath, atomically: true, encoding: .utf8)
                 print("appendTestData CSV file created at: \(filePath)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func concatenateAllCurrentQuestions() -> String {
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = csvString.components(separatedBy: "\n")
            var concatenatedQuestions = ""
            
            for line in lines {
                let values = line.components(separatedBy: ";")
                
                // Modify the index below for "currentQuestion"
                let currentQuestionIndex = 3 // Assuming "currentQuestion" is at index 3
                
                if currentQuestionIndex < values.count {
                    let currentQuestion = values[currentQuestionIndex]
                    concatenatedQuestions.append(currentQuestion)
                    concatenatedQuestions.append("\n") // Add a newline separator
                }
            }
            
            return concatenatedQuestions
        } catch {
            print("Error reading data from CSV file: \(error)")
            return ""
        }
    }
    
    func concatenateLastFiveCurrentQuestions() -> String {
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = csvString.components(separatedBy: "\n")
            var concatenatedQuestions = ""

            // Modify the index below for "currentQuestion"
            let currentQuestionIndex = 3 // Assuming "currentQuestion" is at index 3

            for line in lines.suffix(6).dropFirst() {
                let values = line.components(separatedBy: ";")

                if currentQuestionIndex < values.count {
                    let currentQuestion = values[currentQuestionIndex]
                    concatenatedQuestions.append(currentQuestion)
                    concatenatedQuestions.append("\n") // Add a newline separator
                }
            }

            return concatenatedQuestions
        } catch {
            print("Error reading data from CSV file: \(error)")
            return ""
        }
    }

    
    func clearCSVFile(filePath: String) {
        do {
            let emptyString = ""
            try emptyString.write(toFile: filePath, atomically: false, encoding: .utf8)
            print("CSV file cleared successfully. \(filePath)")
        } catch {
            print("Error clearing the CSV file: \(error)")
        }
    }

    
    func appendCSVFiles(sourcePath: String, destinationPath: String) {
        do {
            // Read content from the source file
            let sourceContent = try String(contentsOfFile: sourcePath, encoding: .utf8)
            
            // Read content from the destination file
            var destinationContent = (try? String(contentsOfFile: destinationPath, encoding: .utf8)) ?? ""
            
            // Append source content to destination content
            destinationContent.append(sourceContent)
            
            // Write the combined content to the destination file
            try destinationContent.write(toFile: destinationPath, atomically: false, encoding: .utf8)
            print("Content from \(sourcePath) appended to \(destinationPath) successfully.")
        } catch {
            print("Error appending files: \(error)")
        }
    }
    
    
    private func readData(atIndex index: Int) -> String? {
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let values = csvString.components(separatedBy: ",")
            
            if index < values.count {
                return values[index]
            }
            return nil
        } catch {
            print("Error reading data from CSV file: \(error)")
            return nil
        }
    }
    
    
    
    
    
    
    
    // in DataManager used to update testdetails forID: search for testId-1 and get atIndex: DataContractIOS.CSVquestionColumn or options
    // and show at TestDetailModel
    func readConcatenatedData(forID targetId: Int, atIndex searchColumnIndex: Int) -> String? {
        var resultValues: String = "" // Declare the array outside the loop
        //print("targetId \(targetId)")

        do {
             // Read the content of the CSV file
             let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
             // print("searchColumnIndex \(searchColumnIndex)")
             // Split the CSV string into rows
             let rows = csvString.components(separatedBy: "\n")
             
             // Iterate through the rows to find the target value in the specified column
            for index in 0..<(rows.count - 1) { // Loop one row less
                let row = rows[index]

                 let columns = row.components(separatedBy: ";")
                 // Check if the row has enough columns
                 if searchColumnIndex < columns.count {
                     // retrieve values at searched columns
                     let idValues = columns[DataContractIOS.CSVtestIdColumn]
                     //print("values \(idValues)")

                     // Check if the value in the search column matches the desired value
                     if idValues == String(targetId) {
                        // print("idValues \(idValues)")

                         // Retrieve the value in the specified result column for the matching row
                         guard searchColumnIndex < columns.count else {
                             print("Result column index is out of bounds")
                             return ""
                         }
                         
                         let resultValue = columns[searchColumnIndex]
                         resultValues.append(resultValue + "\n")
                         //print("Found value '\(targetId)' in column at index \(searchColumnIndex). Result value: \(resultValue)")
                         // Do something with the result value or break the loop as needed
                     }
                 }
             }
         } catch {
             print("Error reading the CSV file: \(error)")
         }
        return resultValues
    }
    
    // with this func get any column results for any expereince for all solved questions
    func readSelectedExperienceData(forSelectedExperience targetExperience: String, atIndex searchColumnIndex: Int) -> String? {
        var resultValues: String = "" // Declare the array outside the loop
        //print("targetId \(targetId)")
       // print("CSVManager readSelectedExperienceData targetExperience \(targetExperience) searchColumnIndex \(searchColumnIndex) ")
        do {
             // Read the content of the CSV file
             let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
             // Split the CSV string into rows
             let rows = csvString.components(separatedBy: "\n")
           // print("rows \(rows.count)")
             // Iterate through the rows to find the target value in the specified column
            for index in 0..<(rows.count - 1) { // Loop one row less
                let row = rows[index]

                 let columns = row.components(separatedBy: ";")
               // print("searchColumnIndex \(columns.count)")
                 // Check if the row has enough columns
                 if searchColumnIndex < columns.count {
                     // retrieve values at searched columns
                     let idValues = columns[DataContractIOS.CSVExperienceColumn]
                     //print("values \(idValues)")

                     // Check if the value in the search column matches the desired value
                     if idValues == String(targetExperience) {
                        // print("idValues \(idValues)")
                        
                         // Retrieve the value in the specified result column for the matching row
                         guard searchColumnIndex < columns.count else {
                             print("Result column index is out of bounds")
                             return ""
                         }
                         
                         let resultValue = columns[searchColumnIndex]
                         resultValues.append(resultValue + "\n")
                       //  print("resultValues \(resultValues)")

                         //print("Found value '\(targetId)' in column at index \(searchColumnIndex). Result value: \(resultValue)")
                         // Do something with the result value or break the loop as needed
                     }
                 }
             }
         } catch {
             print("Error reading the CSV file: \(error)")
         }
        return resultValues
    }

    

    // Function adjusted to filter by a boolean accuracy value
    func readSelectedExperienceAndAccuracyData(forSelectedExperience targetExperience: String) -> String? {
        var resultValues: String = "" // This will accumulate matching questions

        do {
            // Read the content of the CSV file
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            // Split the CSV string into rows
            let rows = csvString.components(separatedBy: "\n")

            // Iterate through the rows
            for row in rows {
                let columns = row.components(separatedBy: ";")
                // Check if the row has enough columns for experience and accuracy
                if columns.count > max(DataContractIOS.CSVExperienceColumn, DataContractIOS.CSVaccuracyColumn) {
                    // Retrieve experience and accuracy values
                    let experienceValue = columns[DataContractIOS.CSVExperienceColumn]
                    let accuracyValue = columns[DataContractIOS.CSVaccuracyColumn]
                    
                    // Convert accuracyValue to a boolean
                    
                    if experienceValue == targetExperience && accuracyValue == "false" {
                        // If the row matches both conditions, append the question to the result
                        let question = columns[DataContractIOS.CSVquestionColumn]
                        resultValues.append(question + "\n")
                    }
                }
            }
        } catch {
            print("Error reading the CSV file: \(error)")
        }
        return resultValues.trimmingCharacters(in: .whitespacesAndNewlines) // Trim trailing newline
    }

    
    
}
