//
//  RewardedAdRep.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 22.01.2024.
//

import Foundation
import GoogleMobileAds
import SwiftUI


class RewardedAdModel:NSObject, ObservableObject, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    @Published var isRewardedAdReady: Bool = false


    override init() {
          super.init()
          loadRewardedAd()
          print("RewardedAdModel init")
      }
    



    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ rewardedAd: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ rewardedAd: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ rewardedAd: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adWillDismissFullScreenContent(_ rewardedAd: GADFullScreenPresentingAd) {
      print("adWillDismissFullScreenContent full screen content.")
    }

    func loadRewardedAd() {
        let adUnitID = DataContractIOS.rewardedTestId
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) { rewardedAd, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error)")
            } else {
                print("Rewarded ad loaded successfully")
                self.rewardedAd = rewardedAd
                self.rewardedAd?.fullScreenContentDelegate = self
  // Set the delegate after the ad is loaded
               // self.rewardedAd?.fullScreenContentDelegate = self as? GADFullScreenContentDelegate
                self.isRewardedAdReady = true
            }
        }
    }

    func showRewardedAd() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            if let rewardedAd = rewardedAd {
                rewardedAd.present(fromRootViewController: rootViewController) {
                    // Rewarded ad was dismissed
                    print("Rewarded ad was dismissed")
                    let currentLife =  PreferenceManager.shared.getUserLife()
                    PreferenceManager.shared.updateUserLife(userLife: currentLife+1)
                    self.loadRewardedAd()  // Reload ad for future use
                }
            } else {
                print("Rewarded ad not ready yet. Try again later.")
            }
        } else {
            print("Unable to retrieve root view controller.")
        }
    }
}


