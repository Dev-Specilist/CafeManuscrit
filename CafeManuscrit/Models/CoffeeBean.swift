//
//  CoffeeBean.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/3/25.
//

import Foundation

struct CoffeeBean: Codable {
    let name: String
    let origin: String
    let roastLevel: RoastLevel
    let processingMethod: String?
    let description: String?
    
    static let dummyBean1 = CoffeeBean(
        name: "콜롬비아 수프리모",
        origin: "콜롬비아",
        roastLevel: .medium,
        processingMethod: "워시드",
        description: "부드럽고 균형잡힌 맛"
    )
    
    static let dummyBean2 = CoffeeBean(
        name: "에티오피아 예가체프",
        origin: "에티오피아",
        roastLevel: .light,
        processingMethod: "내추럴",
        description: "과일향과 꽃향이 풍부"
    )
}
