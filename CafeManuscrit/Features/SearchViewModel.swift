import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var sort: FeedSortOption = .latest
    @Published var filter: RecipeFilter = .none

    @Published private(set) var results: [RecipeItem] = []
    @Published private(set) var nextCursor: String?
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var hasSearched = false
    @Published private(set) var lastRequestParams: [String: String] = [:]

    var isEmptyResult: Bool {
        hasSearched && !isLoading && results.isEmpty
    }

    func search(using repository: RecipeRepository, reset: Bool = true) async {
        let requestCursor = reset ? nil : nextCursor

        if reset {
            nextCursor = nil
            results = []
        }

        isLoading = true
        let page = await repository.search(
            query: query,
            filter: filter,
            sort: sort,
            cursor: requestCursor
        )

        if reset {
            results = page.items
        } else {
            results.append(contentsOf: page.items)
        }

        nextCursor = page.nextCursor
        hasSearched = true
        lastRequestParams = repository.apiParameters(
            query: query,
            sort: sort,
            filter: filter,
            cursor: requestCursor
        )
        isLoading = false
        isLoadingMore = false
    }

    func loadMore(using repository: RecipeRepository) async {
        guard !isLoading else {
            return
        }
        guard !isLoadingMore else {
            return
        }
        guard nextCursor != nil else {
            return
        }

        isLoadingMore = true
        await search(using: repository, reset: false)
    }

    func clearFilters() {
        filter = .none
    }

    func updateSort(_ nextSort: FeedSortOption, using repository: RecipeRepository) async {
        guard sort != nextSort else {
            return
        }
        sort = nextSort
        await search(using: repository)
    }
}
