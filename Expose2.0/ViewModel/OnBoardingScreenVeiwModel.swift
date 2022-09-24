//
//  OnBoardingScreenVeiwModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 8/9/22.
//

import Combine

class OnBoardingScreenViewModel: ObservableObject{
    @Published var OnBoardingStepArray: [OnBoardingStep] = [
        OnBoardingStep(Image: "heart.fill", Text: "WE CARE ABOUT PRIVACY!"),
        OnBoardingStep(Image: "nosign", Text: "Exposé DOES NOT keep or share any of your photos or information with any third parties nor do we store it!"),
        OnBoardingStep(Image: "lasso.and.sparkles", Text: "We only use your photos to curate your interest and give you options of places to get exposed to around you! That's it!"),
    ]
    
    @Published var photoViewIsPresented: Bool = false
}
