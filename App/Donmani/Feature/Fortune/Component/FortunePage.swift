//
//  FortunePage.swift
//  Donmani
//
//  Created by 문종식 on 6/21/26.
//

import SwiftUI
import DesignSystem
import Domain

struct FortunePage: View {
    private let sidePeek: CGFloat = 20
    private let itemSpacing: CGFloat = 20
    private let fortunes: [Fortune]
    @Binding private var selectedDay: Day
    private let referenceToday: Day
    private let referenceYesterday: Day
    private let hasTodayRecord: Bool
    private let hasYesterdayRecord: Bool
    private let isFortuneCardFlipped: (Day) -> Bool
    private let touchFortuneCardAction: (Day) -> Void
    private let touchRecordAction: (Day) -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning = false

    init(
        fortunes: [Fortune],
        selectedDay: Binding<Day>,
        referenceToday: Day,
        referenceYesterday: Day,
        hasTodayRecord: Bool,
        hasYesterdayRecord: Bool,
        isFortuneCardFlipped: @escaping (Day) -> Bool,
        touchFortuneCardAction: @escaping (Day) -> Void,
        touchRecordAction: @escaping (Day) -> Void
    ) {
        self.fortunes = fortunes
        self._selectedDay = selectedDay
        self.referenceToday = referenceToday
        self.referenceYesterday = referenceYesterday
        self.hasTodayRecord = hasTodayRecord
        self.hasYesterdayRecord = hasYesterdayRecord
        self.isFortuneCardFlipped = isFortuneCardFlipped
        self.touchFortuneCardAction = touchFortuneCardAction
        self.touchRecordAction = touchRecordAction
    }

    var body: some View {
        GeometryReader { proxy in
            let horizontalInset = sidePeek + itemSpacing
            let cardWidth = max(0, proxy.size.width - (horizontalInset * 2))
            let pageStride = cardWidth + itemSpacing
            let visibleFortunes = Array(fortunesAroundCurrent.enumerated())

            HStack(spacing: itemSpacing) {
                ForEach(visibleFortunes, id: \.offset) { _, fortune in
                    page(fortune: fortune)
                        .frame(width: cardWidth)
                }
            }
            .animation(nil, value: selectedDay)
            .offset(x: -(pageStride * 2) + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isTransitioning, fortunes.count > 1 else {
                            return
                        }
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        guard !isTransitioning, fortunes.count > 1 else {
                            dragOffset = 0
                            return
                        }

                        let threshold = cardWidth * 0.2
                        let translation = value.translation.width

                        if translation <= -threshold {
                            movePage(direction: .next, stride: pageStride)
                        } else if translation >= threshold {
                            movePage(direction: .previous, stride: pageStride)
                        } else {
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
            .padding(.horizontal, horizontalInset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .onChange(of: selectedDay) { _, _ in
            guard !isTransitioning else {
                return
            }
            dragOffset = 0
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func page(fortune: Fortune) -> some View {
        let isFlipped = isFortuneCardFlipped(fortune.day)
        let isSelected = fortune.day == selectedDay
        let recordButtonLabel = recordButtonLabel(for: fortune.day)

        VStack(spacing: 16) {
            FortuneFlipCard(isFlipped: isFlipped)
            .frame(height: 300)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: .s5,
                    style: .continuous
                )
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: .s5,
                    style: .continuous
                )
            )
            .onTapGesture {
                guard isSelected else {
                    return
                }
                withAnimation(.easeInOut(duration: 0.36)) {
                    touchFortuneCardAction(fortune.day)
                }
            }
            .allowsHitTesting(isSelected)

            VStack(alignment: .leading, spacing: 0) {
                DText(
                    fortune.day.fortuneDate,
                    style: .b2,
                    weight: .regular,
                    color: Color.white
                )
                DText(
                    fortune.title,
                    style: .h2,
                    weight: .bold,
                    color: Color.white
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let recordButtonLabel {
                Button {
                    guard isSelected else {
                        return
                    }
                    touchRecordAction(fortune.day)
                } label: {
                    ZStack {
                        RoundedRectangle(
                            cornerRadius: .s5,
                            style: .continuous
                        )
                        .fill(ColorPalette.Primary.deepBlue20)
                        DText(
                            recordButtonLabel,
                            style: .h3,
                            weight: .bold,
                            color: .white
                        )
                    }
                }
                .frame(height: 58)
                .disabled(!isSelected)
                .allowsHitTesting(isSelected)
            }
            
            Spacer()
        }
    }

    private enum Direction {
        case previous
        case next
    }

    private var currentIndex: Int {
        fortunes.firstIndex(where: { $0.day == selectedDay }) ?? 0
    }

    private var fortunesAroundCurrent: [Fortune] {
        guard !fortunes.isEmpty else {
            return Array(repeating: .empty, count: 5)
        }

        return (-2...2).map { offset in
            fortunes[wrappedIndex(currentIndex + offset)]
        }
    }

    private var previousFortune: Fortune {
        fortunes[safe: wrappedIndex(currentIndex - 1)] ?? .empty
    }

    private var nextFortune: Fortune {
        fortunes[safe: wrappedIndex(currentIndex + 1)] ?? .empty
    }

    private func wrappedIndex(_ index: Int) -> Int {
        guard !fortunes.isEmpty else {
            return 0
        }
        let count = fortunes.count
        return ((index % count) + count) % count
    }

    private func movePage(direction: Direction, stride: CGFloat) {
        isTransitioning = true

        withAnimation(.easeOut(duration: 0.22)) {
            switch direction {
            case .previous:
                dragOffset = stride
            case .next:
                dragOffset = -stride
            }
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(220))
            switch direction {
            case .previous:
                selectedDay = previousFortune.day
            case .next:
                selectedDay = nextFortune.day
            }
            dragOffset = 0
            isTransitioning = false
        }
    }

    private func recordButtonLabel(for day: Day) -> String? {
        if day == referenceToday, !hasTodayRecord {
            return "오늘 소비 기록하기"
        }
        if day == referenceYesterday, !hasYesterdayRecord {
            return "어제 소비 기록하기"
        }
        return nil
    }
}

private struct FortuneFlipCard: View, Animatable {
    var progress: CGFloat

    init(isFlipped: Bool) {
        self.progress = isFlipped ? 1 : 0
    }

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        ZStack {
            if progress < 0.5 {
                cardFace(ColorPalette.Semantic.dailyFortuneBackground)
                    .scaleEffect(
                        x: max(0.001, 1 - (progress * 2)),
                        y: 1,
                        anchor: .center
                    )
            } else {
                cardFace(ColorPalette.Primary.deepBlue20)
                    .scaleEffect(
                        x: max(0.001, (progress - 0.5) * 2),
                        y: 1,
                        anchor: .center
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func cardFace(_ color: Color) -> some View {
        RoundedRectangle(
            cornerRadius: .s5,
            style: .continuous
        )
        .fill(color)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    PreviewFortunePage()
}

private struct PreviewFortunePage: View {
    @State private var selectedDay: Day = .today

    private let fortunes = (0..<7)
        .compactMap { offset in
            Calendar.current.date(byAdding: .day, value: -(6 - offset), to: Date())
        }
        .map { date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let day = Day(
                year: components.year ?? 0,
                month: components.month ?? 0,
                day: components.day ?? 0
            )
            return Fortune(
                day: day,
                title: "\(day.day)일 운세",
                subtitle: "",
                content: "",
                item: ""
            )
        }

    var body: some View {
        FortunePage(
            fortunes: fortunes,
            selectedDay: $selectedDay,
            referenceToday: .today,
            referenceYesterday: .yesterday,
            hasTodayRecord: false,
            hasYesterdayRecord: false,
            isFortuneCardFlipped: { _ in false },
            touchFortuneCardAction: { _ in },
            touchRecordAction: { _ in }
        )
        .onAppear {
            selectedDay = fortunes.last?.day ?? .today
        }
    }
}
