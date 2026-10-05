import Foundation
import SwiftUI


class ChatGPT {
    private let apiKey: String

    init(apiKey: String? = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]) {
        self.apiKey = apiKey ?? ""
    }
    
    func sendMessage(message: String, completion: @escaping (String?) -> Void) {
        guard !apiKey.isEmpty else {
            print("Error: OPENAI_API_KEY is not configured")
            completion(nil)
            return
        }

        // Create the request
        print("sendMessage called")
        
        // Include modified current question and previous questions in the conversation history
        var conversationHistory: [[String: Any]] = [
            ["role": "system", "content": "You are a helpful assistant experienced in Data Science."]
        ]
        
        // to provide previous wrong results
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvManager = CSVManager(filePath: csvFilePath)
        // previous questions
        let lastFiveCurrentQuestions = csvManager.concatenateLastFiveCurrentQuestions()
        //let allCurrentQuestions = csvManager.concatenateAllCurrentQuestions()
        // print ("allCurrentQuestions \(allCurrentQuestions)")
        
        let modifiedCurrentQuestion = message + "?"
        let questionsArray = lastFiveCurrentQuestions.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        for question in questionsArray {
            conversationHistory.append(["role": "user", "content": question])
        }
        
        // print ("conversationHistory \(conversationHistory)")
        
        
        // Add the current user's message
        // Add the modified current question
        conversationHistory.append(["role": "user", "content": modifiedCurrentQuestion])
        //print ("conversationHistory2 \(conversationHistory)")
        
        let urlString = "https://api.openai.com/v1/chat/completions"
        
        let parameters: [String: Any] = [
            "messages": conversationHistory,
            "model": "gpt-3.5-turbo",
        ]
        

        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 45 // Set a longer timeout duration (in seconds)
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: Failed to serialize request parameters")
            completion(nil)
            return
        }
        
        // Send the request
        DispatchQueue.global().async {
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    if let urlError = error as? URLError, urlError.code == .timedOut {
                        print("Request timed out")
                        completion(nil) // Informing the caller about the timeout
                        self.sendMessage(message: message, completion: completion) // Retry the request
                    } else {
                        print("Error in data task: \(error)")
                        completion(nil)
                    }
                    return
                }
                guard let data = data, error == nil else {
                    print("Error: No data received in response")
                    completion(nil)
                    return
                }
                
                do {
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                      //  print("CHATGPT Response received:", response) // Print the response for debugging
                        if let choices = response["choices"] as? [[String: Any]], let firstChoice = choices.first {
                            if let message = firstChoice["message"] as? [String: Any], let content = message["content"] as? String {
                                // self.parseAndPopulateQuestions(content)
                                // print("CHATGPT content received:", content) // Print the response for debugging
                                completion(content)
                            } else {
                                print("Error: Unable to extract assistant's message")
                                completion(nil)
                            }
                        } else {
                            print("Error: Unexpected response format")
                            completion(nil)
                        }
                    } else {
                        print("Error: Invalid JSON response")
                        completion(nil)
                    }
                } catch {
                    print("Error: Failed to parse JSON response")
                    completion(nil)
                }
            }
            
            task.resume()
        }
    }

}
