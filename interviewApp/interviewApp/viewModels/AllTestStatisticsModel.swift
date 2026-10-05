//
//  AllTestStatisticsModel.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 14.11.2023.
//


import Foundation
import SwiftUI

class AllTestStatisticsModel: ObservableObject {
    
    @Published var statisticsDataSummary: [(testIdName: String, date: String, experience: String, accuracyCount: Int)] = []

    func updateValues() {
        let dataManager = DataManager()
        statisticsDataSummary = dataManager.updateAllStatisticsData()
        // print("AllTestStatisticsModel called \(statisticsDataSummary)")
    }
    
}
