import SwiftUI

struct FilterSheetView: View {
    @Binding var draftFilter: RecipeFilter
    let onApply: () -> Void
    let onClear: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.text("filter.title", default: "필터"))
                .font(.app(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1F1A16"))

            filterPicker(
                title: L10n.text("filter.brew_method", default: "추출 도구"),
                selection: $draftFilter.brewMethod,
                values: BrewMethod.allCases,
                label: { $0.displayName }
            )

            filterPicker(
                title: L10n.text("filter.roast", default: "로스팅"),
                selection: $draftFilter.roastLevel,
                values: RoastLevel.allCases,
                label: { $0.displayName }
            )

            filterPicker(
                title: L10n.text("filter.grind", default: "분쇄도"),
                selection: $draftFilter.grindSize,
                values: GrindSize.allCases,
                label: { $0.title }
            )

            HStack(spacing: 10) {
                Button {
                    onClear()
                } label: {
                    Text(L10n.text("filter.clear", default: "초기화"))
                        .font(.app(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "6A625B"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "D8D2CC"), lineWidth: 1)
                        )
                }

                Button {
                    dismiss()
                    onApply()
                } label: {
                    Text(L10n.text("filter.apply", default: "적용"))
                        .font(.app(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(hex: "8B5E3C"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .presentationDetents([.medium])
    }

    private func filterPicker<T: Hashable>(
        title: String,
        selection: Binding<T?>,
        values: [T],
        label: @escaping (T) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.app(size: 13))
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "4E443D"))

            Picker(title, selection: selection) {
                Text(L10n.text("filter.all", default: "전체")).tag(Optional<T>.none)
                ForEach(values, id: \.self) { value in
                    Text(label(value)).tag(Optional(value))
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(Color(hex: "F5F1ED"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
