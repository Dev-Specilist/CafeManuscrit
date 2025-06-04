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
    let timeFromStart: TimeInterval? // 시작부터 경과 시간 (초)
    let waterAmount: Int? // ml
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
            case stepNumber
            case instruction
            case timeFromStart
            case waterAmount
            case notes
            // id는 제외 - 디코딩/인코딩하지 않음
        }
    
    static let dummySteps: [BrewStep] = [
        BrewStep(
            stepNumber: 1,
            instruction: "필터를 접어서 드리퍼에 넣고 뜨거운 물로 헹궈주세요.",
            timeFromStart: 0,
            waterAmount: nil,
            notes: "종이 냄새 제거"
        ),
        BrewStep(
            stepNumber: 2,
            instruction: "중간 굵기로 갈은 커피 원두 20g을 넣어주세요.",
            timeFromStart: 30,
            waterAmount: nil,
            notes: "소금 정도의 굵기"
        ),
        BrewStep(
            stepNumber: 3,
            instruction: "30초간 블루밍을 위해 50ml의 물을 부어주세요.",
            timeFromStart: 60,
            waterAmount: 50,
            notes: "원두 전체가 젖도록"
        ),
        BrewStep(
            stepNumber: 4,
            instruction: "원을 그리며 천천히 150ml를 더 부어주세요.",
            timeFromStart: 90,
            waterAmount: 150,
            notes: "2분 30초까지"
        ),
        BrewStep(
            stepNumber: 5,
            instruction: "마지막으로 100ml를 부어 총 300ml가 되도록 해주세요.",
            timeFromStart: 150,
            waterAmount: 100,
            notes: "4분 안에 완료"
        )
    ]
}
