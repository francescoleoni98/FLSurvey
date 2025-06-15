//
//  OpenTextQuestionView.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI

struct OpenTextQuestionView: View {

	var page: SurveyPage

	@State private var text: String = ""

	@ObservedObject var surveyManager: SurveyManager

	@FocusState private var focused: Bool

	var body: some View {
		if let question = page.questions.first {
			ScrollView {
				TextEditor(text: $text)
					.frame(height: 150)
					.padding()
					.focused($focused)
					.tint(Config.shared.brandColor)
					.scrollContentBackground(.hidden)
					.background(Config.shared.brandColor.opacity(0.05), in: .rect(cornerRadius: 12))
					.overlay {
						RoundedRectangle(cornerRadius: 12)
							.stroke(Config.shared.brandColor, lineWidth: 1)
					}
					.padding(1)
					.onAppear {
						focused = true
					}
					.onChange(of: text) { text in
						surveyManager.saveAnswer(questionId: question.id, value: text.trimmingCharacters(in: .whitespacesAndNewlines))
					}
					.onChange(of: page) { _ in
						text = ""
					}
			}
			.scrollIndicators(.hidden)
		}
	}
}




struct RectangularButton: View {

	var title: String.LocalizationValue
	var primary: Bool = true
	var isLoading: Bool = false
	var action: () -> Void

	public var body: some View {
		Button {
			action()
		} label: {
			VStack {
				if isLoading {
					ProgressView()
						.tint(primary ? Config.shared.foregroundColor : Config.shared.brandColor)
#if os(macOS)
						.scaleEffect(0.5)
#endif
				} else {
					Text(String(localized: title))
						.bold()
						.multilineTextAlignment(.center)
				}
			}
			.foregroundStyle(primary ? Config.shared.foregroundColor : Config.shared.brandColor)
			.frame(maxWidth: .infinity)
#if os(iOS)
			.frame(height: 50)
			.hoverEffect()
#else
			.frame(height: 40)
#endif
			.background(Config.shared.brandColor.opacity(primary ? 1 : 0.05), in: .rect(cornerRadius: 16))
		}
		.buttonStyle(.plain)
		.disabled(isLoading)
	}
}
