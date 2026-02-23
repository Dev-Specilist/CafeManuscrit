import Foundation

@MainActor
final class RecipeRepository: ObservableObject {
    enum RepositoryError: LocalizedError {
        case notFound
        case actionFailed

        var errorDescription: String? {
            switch self {
            case .notFound:
                return L10n.text("repo.error.not_found", default: "레시피를 찾을 수 없습니다.")
            case .actionFailed:
                return L10n.text("repo.error.action_failed", default: "요청 처리에 실패했습니다.")
            }
        }
    }

    @Published private(set) var recipes: [RecipeItem]
    var simulateActionFailure = false

    init(seedRecipes: [RecipeItem]? = nil) {
        self.recipes = seedRecipes ?? RecipeRepository.makeSeedRecipes()
    }

    func feed(sort: FeedSortOption, cursor: String?, pageSize: Int = 6) async -> RecipePage {
        let sorted = sortedRecipes(recipes, by: sort)
        return paginate(items: sorted, cursor: cursor, pageSize: pageSize)
    }

    func search(
        query: String,
        filter: RecipeFilter,
        sort: FeedSortOption,
        cursor: String?,
        pageSize: Int = 6
    ) async -> RecipePage {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        let filtered = recipes.filter { recipe in
            if !normalizedQuery.isEmpty {
                let haystack = [recipe.title, recipe.beanName, recipe.authorName] + recipe.tags
                let matchesQuery = haystack.joined(separator: " ").lowercased().contains(normalizedQuery)
                if !matchesQuery {
                    return false
                }
            }

            if let brewMethod = filter.brewMethod, recipe.brewMethod != brewMethod {
                return false
            }

            if let roastLevel = filter.roastLevel, recipe.roastLevel != roastLevel {
                return false
            }

            if let grindSize = filter.grindSize, recipe.grindSize != grindSize {
                return false
            }

            return true
        }

        let sorted = sortedRecipes(filtered, by: sort)
        return paginate(items: sorted, cursor: cursor, pageSize: pageSize)
    }

    func bookmarkedRecipes(sort: FeedSortOption = .latest) -> [RecipeItem] {
        let bookmarked = recipes.filter(\.isBookmarked)
        return sortedRecipes(bookmarked, by: sort)
    }

    func recipe(id: String) -> RecipeItem? {
        recipes.first(where: { $0.id == id })
    }

    func setRecipe(_ recipe: RecipeItem) {
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else {
            return
        }
        recipes[index] = recipe
    }

    func toggleLike(recipeID: String) async throws -> RecipeItem {
        guard let index = recipes.firstIndex(where: { $0.id == recipeID }) else {
            throw RepositoryError.notFound
        }

        let original = recipes[index]
        var updated = original
        updated.isLiked.toggle()
        updated.likeCount = max(0, updated.likeCount + (updated.isLiked ? 1 : -1))
        recipes[index] = updated

        try await Task.sleep(for: .milliseconds(250))
        if shouldFailAction {
            recipes[index] = original
            throw RepositoryError.actionFailed
        }

        return updated
    }

    func toggleBookmark(recipeID: String) async throws -> RecipeItem {
        guard let index = recipes.firstIndex(where: { $0.id == recipeID }) else {
            throw RepositoryError.notFound
        }

        let original = recipes[index]
        var updated = original
        updated.isBookmarked.toggle()
        updated.bookmarkCount = max(0, updated.bookmarkCount + (updated.isBookmarked ? 1 : -1))
        recipes[index] = updated

        try await Task.sleep(for: .milliseconds(250))
        if shouldFailAction {
            recipes[index] = original
            throw RepositoryError.actionFailed
        }

        return updated
    }

    func createRecipe(from draft: RecipeDraft, authorName: String, userId: String) -> RecipeItem? {
        guard let recipe = draft.toRecipe(authorName: authorName, userId: userId) else {
            return nil
        }

        recipes.insert(recipe, at: 0)
        return recipe
    }

    func apiParameters(
        query: String? = nil,
        sort: FeedSortOption,
        filter: RecipeFilter,
        cursor: String?
    ) -> [String: String] {
        var params: [String: String] = ["sort": sort.apiValue]
        filter.apiParameters.forEach { params[$0.key] = $0.value }

        if let query {
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                params["q"] = trimmed
            }
        }

        if let cursor, !cursor.isEmpty {
            params["cursor"] = cursor
        }

        return params
    }

    private var shouldFailAction: Bool {
        simulateActionFailure && Int.random(in: 0..<4) == 0
    }

    private func sortedRecipes(_ input: [RecipeItem], by sort: FeedSortOption) -> [RecipeItem] {
        switch sort {
        case .latest:
            return input.sorted { lhs, rhs in
                if lhs.createdAt == rhs.createdAt {
                    return lhs.id > rhs.id
                }
                return lhs.createdAt > rhs.createdAt
            }
        case .popular:
            return input.sorted { lhs, rhs in
                if lhs.likeCount == rhs.likeCount {
                    return lhs.createdAt > rhs.createdAt
                }
                return lhs.likeCount > rhs.likeCount
            }
        }
    }

    private func paginate(items: [RecipeItem], cursor: String?, pageSize: Int) -> RecipePage {
        let start = Int(cursor ?? "") ?? 0
        guard start < items.count else {
            return RecipePage(items: [], nextCursor: nil)
        }

        let end = min(start + pageSize, items.count)
        let page = Array(items[start..<end])
        let next = end < items.count ? String(end) : nil
        return RecipePage(items: page, nextCursor: next)
    }
}

private extension RecipeRepository {
    static func makeSeedRecipes() -> [RecipeItem] {
        func step(_ order: Int, _ description: String, _ sec: Int, _ water: Double?) -> RecipeStepItem {
            RecipeStepItem(stepOrder: order, description: description, durationSec: sec, waterAmountMl: water)
        }

        let all: [RecipeItem] = [
            RecipeItem(
                id: "r1",
                title: "V60 Morning Clarity",
                summary: "Clean and sweet daily V60 recipe",
                authorName: "Emma",
                beanName: "Ethiopia Yirgacheffe",
                beanOrigin: "Ethiopia",
                roastLevel: .light,
                processMethod: "Washed",
                brewMethod: .v60,
                grindSize: .medium,
                grinderName: "Comandante C40",
                grinderSetting: "23 clicks",
                waterTemperature: 93,
                coffeeAmountG: 15,
                waterAmountMl: 240,
                totalBrewTimeSec: 170,
                steps: [
                    step(1, "뜸들이기", 30, 40),
                    step(2, "1차 푸어", 45, 110),
                    step(3, "2차 푸어", 55, 90),
                    step(4, "드로우다운", 40, nil)
                ],
                tags: ["초보추천", "밸런스"],
                imageURL: "https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?auto=format&fit=crop&w=1200&q=80",
                likeCount: 142,
                bookmarkCount: 88,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-3600)
            ),
            RecipeItem(
                id: "r2",
                title: "Kalita Sweet Cocoa",
                summary: "Round body and cocoa finish",
                authorName: "Noah",
                beanName: "Colombia Huila",
                beanOrigin: "Colombia",
                roastLevel: .medium,
                processMethod: "Washed",
                brewMethod: .kalita,
                grindSize: .mediumFine,
                grinderName: "Niche Zero",
                grinderSetting: "19",
                waterTemperature: 92,
                coffeeAmountG: 18,
                waterAmountMl: 290,
                totalBrewTimeSec: 205,
                steps: [
                    step(1, "뜸들이기", 35, 50),
                    step(2, "중심 푸어", 75, 140),
                    step(3, "바깥 푸어", 60, 100),
                    step(4, "드로우다운", 35, nil)
                ],
                tags: ["코코아", "중배전"],
                imageURL: "https://images.unsplash.com/photo-1485808191679-5f86510681a2?auto=format&fit=crop&w=1200&q=80",
                likeCount: 98,
                bookmarkCount: 65,
                isLiked: false,
                isBookmarked: true,
                createdAt: .now.addingTimeInterval(-7200)
            ),
            RecipeItem(
                id: "r3",
                title: "Chemex Floral High",
                summary: "Crisp floral cup for weekend",
                authorName: "Mina",
                beanName: "Kenya AA",
                beanOrigin: "Kenya",
                roastLevel: .mediumLight,
                processMethod: "Washed",
                brewMethod: .chemex,
                grindSize: .mediumCoarse,
                grinderName: "Baratza Encore",
                grinderSetting: "22",
                waterTemperature: 94,
                coffeeAmountG: 20,
                waterAmountMl: 320,
                totalBrewTimeSec: 250,
                steps: [
                    step(1, "필터 린스", 30, nil),
                    step(2, "뜸들이기", 40, 60),
                    step(3, "메인 푸어", 120, 200),
                    step(4, "마무리", 60, 60)
                ],
                tags: ["플로럴", "주말"],
                imageURL: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=1200&q=80",
                likeCount: 188,
                bookmarkCount: 101,
                isLiked: true,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-10800)
            ),
            RecipeItem(
                id: "r4",
                title: "AeroPress Citrus Boost",
                summary: "Bright cup with short contact",
                authorName: "Jin",
                beanName: "Rwanda Gitesi",
                beanOrigin: "Rwanda",
                roastLevel: .light,
                processMethod: "Natural",
                brewMethod: .aeropress,
                grindSize: .mediumFine,
                grinderName: "Comandante C40",
                grinderSetting: "17 clicks",
                waterTemperature: 91,
                coffeeAmountG: 17,
                waterAmountMl: 230,
                totalBrewTimeSec: 120,
                steps: [
                    step(1, "투입", 20, nil),
                    step(2, "교반", 30, 120),
                    step(3, "프레스", 70, 110)
                ],
                tags: ["산미", "짧은추출"],
                imageURL: "https://images.unsplash.com/photo-1521302080334-4bebac2763a6?auto=format&fit=crop&w=1200&q=80",
                likeCount: 73,
                bookmarkCount: 42,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-14400)
            ),
            RecipeItem(
                id: "r5",
                title: "French Press Deep Body",
                summary: "Heavy body and dark chocolate notes",
                authorName: "Ari",
                beanName: "Brazil Cerrado",
                beanOrigin: "Brazil",
                roastLevel: .dark,
                processMethod: "Natural",
                brewMethod: .frenchPress,
                grindSize: .coarse,
                grinderName: "Timemore C3",
                grinderSetting: "22 clicks",
                waterTemperature: 95,
                coffeeAmountG: 22,
                waterAmountMl: 330,
                totalBrewTimeSec: 300,
                steps: [
                    step(1, "투입", 20, nil),
                    step(2, "푸어", 60, 330),
                    step(3, "브레이크", 40, nil),
                    step(4, "프레스", 180, nil)
                ],
                tags: ["묵직함", "다크"],
                imageURL: "https://images.unsplash.com/photo-1461988320302-91bde64fc8e4?auto=format&fit=crop&w=1200&q=80",
                likeCount: 215,
                bookmarkCount: 140,
                isLiked: false,
                isBookmarked: true,
                createdAt: .now.addingTimeInterval(-18000)
            ),
            RecipeItem(
                id: "r6",
                title: "Pour Over Everyday",
                summary: "Simple and repeatable routine",
                authorName: "Kai",
                beanName: "Guatemala Antigua",
                beanOrigin: "Guatemala",
                roastLevel: .medium,
                processMethod: "Washed",
                brewMethod: .pourOver,
                grindSize: .medium,
                grinderName: "Encore ESP",
                grinderSetting: "17",
                waterTemperature: 92,
                coffeeAmountG: 16,
                waterAmountMl: 250,
                totalBrewTimeSec: 190,
                steps: [
                    step(1, "뜸들이기", 30, 45),
                    step(2, "중앙 푸어", 70, 130),
                    step(3, "마무리", 90, 75)
                ],
                tags: ["데일리", "안정적"],
                imageURL: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80",
                likeCount: 56,
                bookmarkCount: 28,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-21600)
            ),
            RecipeItem(
                id: "r7",
                title: "V60 Berry Bloom",
                summary: "Juicy berry aromatics",
                authorName: "Liam",
                beanName: "Ethiopia Guji",
                beanOrigin: "Ethiopia",
                roastLevel: .light,
                processMethod: "Natural",
                brewMethod: .v60,
                grindSize: .mediumFine,
                grinderName: "Comandante C40",
                grinderSetting: "20 clicks",
                waterTemperature: 93,
                coffeeAmountG: 15,
                waterAmountMl: 235,
                totalBrewTimeSec: 175,
                steps: [
                    step(1, "뜸들이기", 25, 40),
                    step(2, "1차 푸어", 65, 100),
                    step(3, "2차 푸어", 85, 95)
                ],
                tags: ["베리", "화사함"],
                imageURL: "https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=1200&q=80",
                likeCount: 121,
                bookmarkCount: 70,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-25200)
            ),
            RecipeItem(
                id: "r8",
                title: "Kalita Honey Cup",
                summary: "Round sweetness and caramel",
                authorName: "Yuna",
                beanName: "Costa Rica Tarrazu",
                beanOrigin: "Costa Rica",
                roastLevel: .medium,
                processMethod: "Honey",
                brewMethod: .kalita,
                grindSize: .medium,
                grinderName: "Niche Zero",
                grinderSetting: "22",
                waterTemperature: 92,
                coffeeAmountG: 17,
                waterAmountMl: 270,
                totalBrewTimeSec: 210,
                steps: [
                    step(1, "뜸들이기", 35, 45),
                    step(2, "1차 푸어", 80, 140),
                    step(3, "2차 푸어", 95, 85)
                ],
                tags: ["달콤함", "허니"],
                imageURL: "https://images.unsplash.com/photo-1497636577773-f1231844b336?auto=format&fit=crop&w=1200&q=80",
                likeCount: 84,
                bookmarkCount: 36,
                isLiked: true,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-28800)
            ),
            RecipeItem(
                id: "r9",
                title: "Chemex Light Tea Body",
                summary: "Tea-like and transparent",
                authorName: "Sora",
                beanName: "Panama Geisha",
                beanOrigin: "Panama",
                roastLevel: .light,
                processMethod: "Washed",
                brewMethod: .chemex,
                grindSize: .mediumCoarse,
                grinderName: "Fellow Ode",
                grinderSetting: "5",
                waterTemperature: 94,
                coffeeAmountG: 22,
                waterAmountMl: 350,
                totalBrewTimeSec: 260,
                steps: [
                    step(1, "뜸들이기", 45, 60),
                    step(2, "메인 푸어", 140, 220),
                    step(3, "마무리", 75, 70)
                ],
                tags: ["티라이크", "게이샤"],
                imageURL: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1200&q=80",
                likeCount: 241,
                bookmarkCount: 166,
                isLiked: false,
                isBookmarked: true,
                createdAt: .now.addingTimeInterval(-32400)
            ),
            RecipeItem(
                id: "r10",
                title: "French Press Weekend",
                summary: "Relaxed weekend heavy cup",
                authorName: "Haru",
                beanName: "Sumatra Mandheling",
                beanOrigin: "Indonesia",
                roastLevel: .mediumDark,
                processMethod: "Wet-Hulled",
                brewMethod: .frenchPress,
                grindSize: .coarse,
                grinderName: "Timemore C3",
                grinderSetting: "25 clicks",
                waterTemperature: 94,
                coffeeAmountG: 21,
                waterAmountMl: 320,
                totalBrewTimeSec: 285,
                steps: [
                    step(1, "푸어", 50, 320),
                    step(2, "브레이크", 45, nil),
                    step(3, "스쿱", 40, nil),
                    step(4, "프레스", 150, nil)
                ],
                tags: ["주말", "바디감"],
                imageURL: "https://images.unsplash.com/photo-1459755486867-b55449bb39ff?auto=format&fit=crop&w=1200&q=80",
                likeCount: 111,
                bookmarkCount: 59,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-36000)
            ),
            RecipeItem(
                id: "r11",
                title: "AeroPress Camp Brew",
                summary: "Fast brew for travel days",
                authorName: "Dae",
                beanName: "House Blend",
                beanOrigin: "Blend",
                roastLevel: .medium,
                processMethod: "Washed",
                brewMethod: .aeropress,
                grindSize: .mediumFine,
                grinderName: "1Zpresso Q",
                grinderSetting: "14",
                waterTemperature: 90,
                coffeeAmountG: 16,
                waterAmountMl: 220,
                totalBrewTimeSec: 130,
                steps: [
                    step(1, "뜸들이기", 20, 40),
                    step(2, "메인 푸어", 40, 120),
                    step(3, "프레스", 70, 60)
                ],
                tags: ["여행", "빠른추출"],
                imageURL: "https://images.unsplash.com/photo-1507133750040-4a8f57021571?auto=format&fit=crop&w=1200&q=80",
                likeCount: 67,
                bookmarkCount: 33,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-39600)
            ),
            RecipeItem(
                id: "r12",
                title: "Pour Over Bright Morning",
                summary: "Simple bright cup before work",
                authorName: "Rin",
                beanName: "Kenya Nyeri",
                beanOrigin: "Kenya",
                roastLevel: .mediumLight,
                processMethod: "Washed",
                brewMethod: .pourOver,
                grindSize: .medium,
                grinderName: "Encore ESP",
                grinderSetting: "18",
                waterTemperature: 93,
                coffeeAmountG: 15,
                waterAmountMl: 240,
                totalBrewTimeSec: 180,
                steps: [
                    step(1, "뜸들이기", 30, 45),
                    step(2, "1차 푸어", 60, 120),
                    step(3, "2차 푸어", 90, 75)
                ],
                tags: ["출근전", "밝은산미"],
                imageURL: "https://images.unsplash.com/photo-1494314671902-399b18174975?auto=format&fit=crop&w=1200&q=80",
                likeCount: 94,
                bookmarkCount: 52,
                isLiked: false,
                isBookmarked: false,
                createdAt: .now.addingTimeInterval(-43200)
            )
        ]

        return all
    }
}
