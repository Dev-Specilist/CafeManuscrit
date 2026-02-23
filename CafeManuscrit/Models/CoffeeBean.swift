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
        name: "Colombia Supremo",
        origin: "Colombia",
        roastLevel: .medium,
        processingMethod: "Washed",
        description: "Smooth and balanced cup"
    )
    
    static let dummyBean2 = CoffeeBean(
        name: "Ethiopia Yirgacheffe",
        origin: "Ethiopia",
        roastLevel: .light,
        processingMethod: "Natural",
        description: "Floral and fruity aroma"
    )
}
