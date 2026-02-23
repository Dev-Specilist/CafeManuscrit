import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var sort: FeedSortOption = .latest
    @Published private(set) var recipes: [RecipeItem] = []
    @Published private(set) var nextCursor: String?
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var lastRequestParams: [String: String] = [:]

    func loadIfNeeded(using repository: RecipeRepository) async {
        guard !hasLoaded else {
            return
        }
        await refresh(using: repository)
    }

    func refresh(using repository: RecipeRepository) async {
        isLoading = true
        let page = await repository.feed(sort: sort, cursor: nil)
        recipes = page.items
        nextCursor = page.nextCursor
        lastRequestParams = repository.apiParameters(sort: sort, filter: .none, cursor: nil)
        hasLoaded = true
        isLoading = false
    }

    func loadMore(using repository: RecipeRepository) async {
        guard !isLoading else {
            return
        }
        guard !isLoadingMore else {
            return
        }
        guard let nextCursor else {
            return
        }

        isLoadingMore = true
        let page = await repository.feed(sort: sort, cursor: nextCursor)
        recipes.append(contentsOf: page.items)
        self.nextCursor = page.nextCursor
        lastRequestParams = repository.apiParameters(sort: sort, filter: .none, cursor: nextCursor)
        isLoadingMore = false
    }

    func updateSort(_ nextSort: FeedSortOption, using repository: RecipeRepository) async {
        guard sort != nextSort else {
            return
        }
        sort = nextSort
        await refresh(using: repository)
    }
}
