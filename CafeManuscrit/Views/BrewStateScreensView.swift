import SwiftUI

struct BrewDeleteMotionView: View {
    var body: some View {
        BrewStateShell {
            BrewLabHeaderView()
            BrewRecipeCard(
                title: ContentText.Brew.quickTitle,
                meta: ContentText.Brew.quickMeta,
                chips: [
                    L10n.text("brew.quick.stat.yield", default: "Yield 2.1"),
                    L10n.text("brew.quick.stat.temp", default: "Temp 93°C")
                ],
                ctaLabel: L10n.text("brew.quick.cta.start", default: "Start Brew"),
                onCTATap: {}
            )
            BrewLogListView(mode: .deleteMotion)
        }
    }
}

struct BrewTabSwitchStateView: View {
    var body: some View {
        BrewStateShell {
            BrewLabHeaderView()

            BrewLogRow(
                title: ContentText.Brew.quickTitle,
                subtitle: ContentText.Brew.tabMorningMeta
            )

            BrewRecipeCard(
                title: ContentText.Brew.log1Title,
                meta: ContentText.Brew.selectedMeta,
                chips: [
                    L10n.text("brew.selected.stat.ratio", default: "Ratio 1:16.7"),
                    L10n.text("brew.selected.stat.temp", default: "Temp 92°C")
                ],
                ctaLabel: L10n.text("brew.quick.cta.start", default: "Start Brew"),
                onCTATap: {}
            )

            BrewLogRow(title: ContentText.Brew.log2Title, subtitle: ContentText.Brew.log2Subtitle)
            BrewLogRow(title: ContentText.Brew.log3Title, subtitle: ContentText.Brew.log3Subtitle)
            BrewLogRow(title: ContentText.Brew.log4Title, subtitle: ContentText.Brew.log4Subtitle)
            BrewLogRow(title: ContentText.Brew.log5Title, subtitle: ContentText.Brew.log5Subtitle)
        }
    }
}

struct BrewStartedStateView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                BrewTimerHeaderView()
                BrewLogRow(
                    title: ContentText.Brew.quickTitle,
                    subtitle: ContentText.Brew.tabMorningMeta
                )
                BrewStartedActiveBrewCard()
                BrewTimerHeroView()
                BrewStartedRecentLogsView()
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "FFFFFF"))
    }
}

// MARK: - Shell

struct BrewStateShell<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                content
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "FFFFFF"))
    }
}

// MARK: - Headers

struct BrewLabHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(L10n.text("brew.lab.title", default: "Brew Lab"))
                    .font(.custom("Inter", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))

                Spacer()

                PenIcon(kind: .add, size: 16, color: Color(hex: "8B5E3C"))
                    .frame(width: 28, height: 28)
            }
            .frame(height: 30)

            Text(L10n.text("brew.lab.subtitle", default: "Dial in your recipe and track each extraction."))
                .font(.custom("Inter", size: 12))
                .foregroundColor(Color(hex: "6A625B"))
                .lineSpacing(2)
        }
    }
}

struct BrewTimerHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(L10n.text("brew.timer.title", default: "Brew Timer"))
                    .font(.custom("Inter", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F1A16"))
                Spacer()
                PenIcon(kind: .add, size: 16, color: Color(hex: "8B5E3C"))
                    .frame(width: 28, height: 28)
            }
            .frame(height: 30)

            Text(L10n.text("brew.timer.subtitle", default: "Brew in progress · Keep extraction smooth"))
                .font(.custom("Inter", size: 11))
                .foregroundColor(Color(hex: "6A625B"))
        }
    }
}

// MARK: - Log List

enum BrewLogListMode {
    case normal
    case deleteMotion
}

struct BrewLogListView: View {
    let mode: BrewLogListMode

    var body: some View {
        VStack(spacing: 10) {
            BrewLogRow(title: ContentText.Brew.log1Title, subtitle: ContentText.Brew.log1Subtitle)

            if mode == .deleteMotion {
                HStack(spacing: 8) {
                    BrewLogRow(
                        title: ContentText.Brew.log2Title,
                        subtitle: ContentText.Brew.log2Subtitle
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "D94A4A"))
                        .frame(width: 72, height: 66)
                        .overlay(
                            Text(L10n.text("brew.delete", default: "Delete"))
                                .font(.custom("Inter", size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 66)
            } else {
                BrewLogRow(title: ContentText.Brew.log2Title, subtitle: ContentText.Brew.log2Subtitle)
            }

            BrewLogRow(title: ContentText.Brew.log3Title, subtitle: ContentText.Brew.log3Subtitle)
            BrewLogRow(title: ContentText.Brew.log4Title, subtitle: ContentText.Brew.log4Subtitle)
            BrewLogRow(title: ContentText.Brew.log5Title, subtitle: ContentText.Brew.log5Subtitle)
        }
    }
}

// MARK: - Timer Hero

struct BrewTimerHeroView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("01:12")
                .font(.custom("Inter", size: 56))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2F2721"))

            Text(L10n.text("brew.timer.step.big", default: "CURRENT STEP 2 · BLOOM"))
                .font(.custom("Inter", size: 20))
                .fontWeight(.heavy)
                .foregroundColor(Color(hex: "7C4A2D"))

            HStack(spacing: 8) {
                BrewStepChip(label: L10n.text("brew.timer.step.1", default: "1 READY"))
                BrewStepChip(label: L10n.text("brew.timer.step.2", default: "2 BLOOM"), selected: true)
                BrewStepChip(label: L10n.text("brew.timer.step.3", default: "3 POUR"))
                BrewStepChip(label: L10n.text("brew.timer.step.4", default: "4 FINISH"))
                BrewStepChip(label: L10n.text("brew.timer.step.5", default: "5 DONE"))
            }
            .frame(height: 44)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "FCF9F5"))
                .overlay(
                    VStack(spacing: 4) {
                        Text(L10n.text("brew.timer.animation.title", default: "BLOOM Animation Area"))
                            .font(.custom("Inter", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "111827"))
                        Text(L10n.text("brew.timer.animation.subtitle", default: "Now: BLOOM (degas)  ·  Next: POUR"))
                            .font(.custom("Inter", size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "4B5563"))
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "E7DED4"), lineWidth: 1)
                )
                .frame(height: 280)

            HStack(spacing: 10) {
                BrewControlButton(text: L10n.text("brew.timer.minus10", default: "-10s"))
                BrewControlButton(text: L10n.text("brew.timer.pause", default: "Pause"))
                BrewControlButton(text: L10n.text("brew.timer.plus10", default: "+10s"))
            }
            .frame(height: 40)

            Text(ContentText.Brew.startedAdjustHint)
                .font(.custom("Inter", size: 12))
                .foregroundColor(Color(hex: "6A625B"))
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 8) {
                BrewSecondaryAction(text: L10n.text("brew.timer.prev", default: "Prev Step"))
                BrewSecondaryAction(text: L10n.text("brew.timer.next", default: "Next Step"))
            }
            .frame(height: 36)

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "C44A3A"))
                .frame(height: 42)
                .overlay(
                    Text(L10n.text("brew.timer.stop", default: "Stop Brew"))
                        .font(.custom("Inter", size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
        }
    }
}

// MARK: - Active Brew Card

struct BrewStartedActiveBrewCard: View {
    var body: some View {
        BrewRecipeCard(
            title: ContentText.Brew.startedActiveTitle,
            meta: ContentText.Brew.startedActiveMeta,
            chips: [
                ContentText.Brew.startedActiveStep,
                ContentText.Brew.startedActiveFlow,
                L10n.text("brew.selected.stat.temp", default: "Temp 92°C")
            ],
            statusText: ContentText.Brew.startedActiveCurrent,
            ctaLabel: L10n.text("brew.quick.cta.start", default: "Start Brew"),
            onCTATap: {}
        )
    }
}

// MARK: - Recent Logs

struct BrewStartedRecentLogsView: View {
    var body: some View {
        VStack(spacing: 10) {
            BrewLogRow(title: ContentText.Brew.log2Title, subtitle: ContentText.Brew.log2Subtitle)
            BrewLogRow(title: ContentText.Brew.log3Title, subtitle: ContentText.Brew.log3Subtitle)
            BrewLogRow(title: ContentText.Brew.log4Title, subtitle: ContentText.Brew.log4Subtitle)
            BrewLogRow(title: ContentText.Brew.log5Title, subtitle: ContentText.Brew.log5Subtitle)
        }
    }
}

// MARK: - Preview

struct BrewStateScreensView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BrewDeleteMotionView()
            BrewTabSwitchStateView()
            BrewStartedStateView()
        }
    }
}
