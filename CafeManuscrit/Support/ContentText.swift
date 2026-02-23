//
//  ContentText.swift
//  CafeManuscrit
//
//  Non-localized content data (user/content titles/tags).
//

import Foundation

enum ContentText {
    enum User {
        static let appleMockName = "Apple User"
        static let googleMockName = "Google User"
    }

    enum Home {
        static let featured1Title = "Ethiopian V60"
        static let featured1Author = "Emma"
        static let featured1Meta = "★ 4.8 · Pour Over"

        static let featured2Title = "Classic Cold Brew"
        static let featured2Author = "Noah"
        static let featured2Meta = "★ 4.7 · Cold Brew"

        static let latest1Title = "Ethiopian V60"
        static let latest1Subtitle = "Floral notes · Medium roast"
        static let latest2Title = "Colombian Flat White"
        static let latest2Subtitle = "Chocolate notes · Smooth body"
    }

    enum Discover {
        static let story1 = "James Hoffmann"
        static let story2 = "Roaster"
        static let postTag1 = "#cafe_manuscrit"
        static let postTag2 = "#brew_daily"
    }

    enum Brew {
        static let quickTitle = "Morning Flat White"
        static let quickMeta = "18g in · 38g out · 29s"
        static let tabMorningMeta = "18g / 38g · 29s · Sweet finish"

        static let log1Title = "V60 · Ethiopia Guji"
        static let log1Subtitle = "15g / 250g · 2:42 · Balanced acidity"
        static let log2Title = "Espresso · Colombia Huila"
        static let log2Subtitle = "18g / 38g · 29s · Sweet finish"
        static let log3Title = "Moka Pot · House Blend"
        static let log3Subtitle = "17g / 120g · 2:10 · Rich body"
        static let log4Title = "Kalita Wave · Kenya AA"
        static let log4Subtitle = "16g / 220g · 1:45 · Nutty and round"
        static let log5Title = "AeroPress · Brazil Cerrado"
        static let log5Subtitle = "20g / 300g · 3:05 · Bright citrus"

        static let selectedMeta = "15g in · 250g out · 2:42"

        static let startedActiveTitle = "V60 · Brewing"
        static let startedActiveMeta = "15g in · 120g out · 1:12"
        static let startedActiveStep = "Step 2/5 · Bloom"
        static let startedActiveFlow = "Flow 2.1 g/s"
        static let startedActiveCurrent = "현재 단계: Bloom (2/5)"
        static let startedAdjustHint = "-10s / +10s 로 단계 타이밍 미세 조정"
    }
}
