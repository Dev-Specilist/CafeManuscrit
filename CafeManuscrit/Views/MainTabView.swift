import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)

            DiscoverFeedView()
                .tag(1)

            BrewLabView()
                .tag(2)

            ProfileView()
                .tag(3)
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color(hex: "FFFFFF"))
        .safeAreaInset(edge: .bottom) {
            CustomMenuBar(selectedTab: $selectedTab)
                .background(
                    Color(hex: "2A211D")
                        .ignoresSafeArea(edges: .bottom)
                )
        }
    }
}

private struct CustomMenuBar: View {
    @Binding var selectedTab: Int

    private struct TabItem {
        let icon: PenIconKind
        let selectedIcon: PenIconKind
        let title: String
    }

    private let items: [TabItem] = [
        TabItem(icon: .home, selectedIcon: .home, title: L10n.text("tab.home.title", default: "Home")),
        TabItem(icon: .search, selectedIcon: .search, title: L10n.text("tab.discover.title", default: "Discover")),
        TabItem(icon: .coffeeMaker, selectedIcon: .coffeeMaker, title: L10n.text("tab.feed.title", default: "Brew")),
        TabItem(icon: .person, selectedIcon: .person, title: L10n.text("tab.profile.title", default: "Profile"))
    ]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "3A2E28"))
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 2) {
                            PenIcon(
                                kind: selectedTab == index ? item.selectedIcon : item.icon,
                                size: 18,
                                color: selectedTab == index ? Color(hex: "2F6DF6") : Color(hex: "8E8E93")
                            )
                            .offset(y: item.icon == .coffeeMaker ? -1 : 0)

                            Text(item.title)
                                .font(.app(size: 10))
                                .fontWeight(selectedTab == index ? .bold : .semibold)
                                .foregroundColor(selectedTab == index ? Color(hex: "2F6DF6") : Color(hex: "8E8E93"))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .frame(height: 68)
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "2A211D"))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppViewModel())
            .environmentObject(RecipeRepository())
    }
}
