//
//  BrewStep.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

struct BrewStep: Identifiable, Codable {
    let id = UUID()
    let stepNumber: Int
    let instruction: String
    let timeFromStart: TimeInterval? // elapsed time from start (seconds)
    let waterAmount: Int? // ml
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
            case stepNumber
            case instruction
            case timeFromStart
            case waterAmount
            case notes
            // Exclude id from encoding/decoding
        }
    
    static let dummySteps: [BrewStep] = [
        BrewStep(
            stepNumber: 1,
            instruction: "Fold the paper filter, place it in the dripper, and rinse with hot water.",
            timeFromStart: 0,
            waterAmount: nil,
            notes: "Remove paper taste"
        ),
        BrewStep(
            stepNumber: 2,
            instruction: "Add 20g of medium-ground coffee.",
            timeFromStart: 30,
            waterAmount: nil,
            notes: "Texture similar to table salt"
        ),
        BrewStep(
            stepNumber: 3,
            instruction: "Pour 50ml for a 30-second bloom.",
            timeFromStart: 60,
            waterAmount: 50,
            notes: "Wet all grounds evenly"
        ),
        BrewStep(
            stepNumber: 4,
            instruction: "Pour another 150ml slowly in circular motions.",
            timeFromStart: 90,
            waterAmount: 150,
            notes: "Reach this step by 2:30"
        ),
        BrewStep(
            stepNumber: 5,
            instruction: "Finish with 100ml, totaling 300ml.",
            timeFromStart: 150,
            waterAmount: 100,
            notes: "Complete within 4 minutes"
        )
    ]
}
